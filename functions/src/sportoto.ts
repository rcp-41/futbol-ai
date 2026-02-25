import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
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
    async () => {
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
    const db = admin.firestore();

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
    const rounds: SportotoRound[] = roundsData.object || roundsData;

    if (!rounds || rounds.length === 0) {
        throw new functions.https.HttpsError(
            "not-found",
            "Yayınlanmış hafta bulunamadı"
        );
    }

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
    const sportotoMatches: SportotoMatch[] = matchesData.object || matchesData;

    if (!sportotoMatches || sportotoMatches.length === 0) {
        throw new functions.https.HttpsError(
            "not-found",
            `Hafta ${latestRound.roundNo} için maç bulunamadı`
        );
    }

    // 3. Firestore'a yaz — mevcut verileri temizle + yenilerini ekle
    const batch = db.batch();
    const collRef = db.collection("sportoto_matches");

    // Eski verileri temizle
    const existingDocs = await collRef.get();
    existingDocs.forEach((doc) => batch.delete(doc.ref));

    // Yeni maçları ekle
    const now = admin.firestore.Timestamp.now();

    for (const sm of sportotoMatches) {
        const matchDate = new Date(sm.match.date);
        const ref = collRef.doc();

        batch.set(ref, {
            homeTeam: {
                name: sm.match.homeTeam.name,
                shortName: sm.match.homeTeam.shortName,
                logoUrl: "",
                formLast5: "",
            },
            awayTeam: {
                name: sm.match.awayTeam.name,
                shortName: sm.match.awayTeam.shortName,
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
                    home: parseInt(sm.match.score.split("-")[0] || "0"),
                    away: parseInt(sm.match.score.split("-")[1] || "0"),
                }
                : null,
            odds: null,
            importance: "normal",
            orderNo: sm.orderNo,
            roundId: latestRound.id,
            createdAt: now,
            updatedAt: now,
        });
    }

    await batch.commit();

    functions.logger.info(
        `✅ Sportoto ${latestRound.roundNo}. hafta — ${sportotoMatches.length} maç eklendi`
    );

    return {
        success: true,
        matchCount: sportotoMatches.length,
        weekNumber: latestRound.roundNo,
    };
}
