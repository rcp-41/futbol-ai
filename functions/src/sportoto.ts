import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import { db } from "./firebase";
import { defineString } from "firebase-functions/params";

const SPORTOTO_API_BASE = "https://webapi.sportoto.gov.tr/api";
const SEASON = defineString("SPORTOTO_SEASON", { default: "2025/2026" });

interface SportotoTeam {
    name: string;
    shortName: string;
    id: number;
}

interface SportotoMatch {
    match: {
        date: string;
        homeTeam: SportotoTeam;
        awayTeam: SportotoTeam;
        score: string | null;
    };
    orderNo: number;
}

interface SportotoRound {
    id: number;
    roundNo: number;
    roundCloseDate: string;
    isPublished: boolean;
}

/**
 * Sportoto API'den güncel hafta maçlarını çekip Firestore'a yazar.
 * - Callable: Manuel tetikleme
 * - Scheduled: Her Pazar 10:00 (Europe/Istanbul)
 */
export const fetchSportotoMatches = functions.https.onCall(
    { region: "europe-west1" },
    async (request) => {
        // Auth check
        if (!request.auth) {
            throw new functions.https.HttpsError(
                "unauthenticated",
                "Giriş yapmanız gerekiyor."
            );
        }
        return await _fetchAndStoreSportotoMatches();
    }
);

/**
 * Zamanlanmış tetikleme — Her Pazar 10:00
 */
export const scheduledSportotoFetch = functions.scheduler.onSchedule(
    {
        schedule: "0 10 * * 0", // Her Pazar 10:00
        timeZone: "Europe/Istanbul",
        region: "europe-west1",
    },
    async () => {
        await _fetchAndStoreSportotoMatches();
    }
);

async function _fetchAndStoreSportotoMatches(): Promise<{
    success: boolean;
    matchCount: number;
    weekNumber: number;
}> {
    // 1. En son yayınlanan haftayı bul
    const roundsUrl =
        `${SPORTOTO_API_BASE}/GameRound?year=${encodeURIComponent(SEASON.value())}&isPublished=true`;

    const roundsRes = await fetch(roundsUrl);
    if (!roundsRes.ok) {
        throw new functions.https.HttpsError(
            "unavailable",
            `Sportoto API yanıt vermedi: ${roundsRes.status}`
        );
    }

    const roundsData = await roundsRes.json();
    const rawRounds = roundsData.object || roundsData;

    if (!Array.isArray(rawRounds) || rawRounds.length === 0) {
        throw new functions.https.HttpsError(
            "not-found",
            "Yayınlanmış hafta bulunamadı"
        );
    }

    // [S-10] Validate round objects have required fields
    const rounds: SportotoRound[] = rawRounds.filter(
        (r: Record<string, unknown>) =>
            typeof r.id === "number" &&
            typeof r.roundNo === "number"
    );

    // En yüksek roundNo = en güncel hafta
    const latestRound = rounds.reduce((max: SportotoRound, r: SportotoRound) =>
        r.roundNo > max.roundNo ? r : max
    );

    // 2. O haftanın maçlarını çek
    const matchesUrl =
        `${SPORTOTO_API_BASE}/GameMatch/GetGameMatches/?gameRoundId=${latestRound.id}`;

    const matchesRes = await fetch(matchesUrl);
    if (!matchesRes.ok) {
        throw new functions.https.HttpsError(
            "unavailable",
            `Sportoto maç API yanıt vermedi: ${matchesRes.status}`
        );
    }

    const matchesData = await matchesRes.json();
    const rawMatches = matchesData.object || matchesData;

    if (!Array.isArray(rawMatches) || rawMatches.length === 0) {
        throw new functions.https.HttpsError(
            "not-found",
            `Hafta ${latestRound.roundNo} için maç bulunamadı`
        );
    }

    // [S-10] Validate match objects have required nested fields
    const sportotoMatches: SportotoMatch[] = rawMatches.filter(
        (m: Record<string, unknown>) =>
            m.match != null &&
            typeof m.match === "object" &&
            typeof (m.match as Record<string, unknown>).date === "string" &&
            (m.match as Record<string, unknown>).homeTeam != null &&
            (m.match as Record<string, unknown>).awayTeam != null
    );

    // 3. Firestore'a yaz — mevcut verileri temizle + yenilerini ekle
    // Batch 500 operasyon limitine dikkat: birden fazla batch kullan
    const collRef = db.collection("sportoto_matches");
    const BATCH_LIMIT = 400; // 500 limitine yaklaşmamak için güvenli sınır

    // Eski verileri temizle (birden fazla batch ile)
    const existingDocs = await collRef.get();
    let deleteBatch = db.batch();
    let opCount = 0;

    for (const doc of existingDocs.docs) {
        deleteBatch.delete(doc.ref);
        opCount++;
        if (opCount >= BATCH_LIMIT) {
            await deleteBatch.commit();
            deleteBatch = db.batch();
            opCount = 0;
        }
    }
    if (opCount > 0) {
        await deleteBatch.commit();
    }

    // Yeni maçları ekle (birden fazla batch ile)
    const now = admin.firestore.Timestamp.now();
    let writeBatch = db.batch();
    let writeCount = 0;

    for (const sm of sportotoMatches) {
        const matchDate = new Date(sm.match.date);
        const ref = collRef.doc();

        writeBatch.set(ref, {
            homeTeam: {
                name: sm.match.homeTeam?.name || "",
                shortName: sm.match.homeTeam?.shortName || "",
                logoUrl: "",
                formLast5: "",
            },
            awayTeam: {
                name: sm.match.awayTeam?.name || "",
                shortName: sm.match.awayTeam?.shortName || "",
                logoUrl: "",
                formLast5: "",
            },
            league: "Spor Toto",
            leagueCountry: "TR",
            week: latestRound.roundNo,
            matchDate: admin.firestore.Timestamp.fromDate(matchDate),
            stadium: "",
            status: sm.match.score ? "completed" : "upcoming",
            score: sm.match.score
                ? {
                    home: parseInt(sm.match.score.split("-")[0] || "0", 10),
                    away: parseInt(sm.match.score.split("-")[1] || "0", 10),
                }
                : null,
            odds: null,
            importance: "normal",
            orderNo: sm.orderNo,
            roundId: latestRound.id,
            createdAt: now,
            updatedAt: now,
        });

        writeCount++;
        if (writeCount >= BATCH_LIMIT) {
            await writeBatch.commit();
            writeBatch = db.batch();
            writeCount = 0;
        }
    }
    if (writeCount > 0) {
        await writeBatch.commit();
    }

    functions.logger.info(
        `✅ Sportoto ${latestRound.roundNo}. hafta — ${sportotoMatches.length} maç eklendi`
    );

    return {
        success: true,
        matchCount: sportotoMatches.length,
        weekNumber: latestRound.roundNo,
    };
}
