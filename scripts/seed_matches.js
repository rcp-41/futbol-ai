// Seed script — Süper Lig 25. Hafta gerçek maç verileri
const admin = require("firebase-admin");

admin.initializeApp({ projectId: "futbol-ai-app" });
const db = admin.firestore();

const matches = [
    {
        homeTeam: { name: "Beşiktaş", shortName: "BJK", logoUrl: "", formLast5: "GGBMG" },
        awayTeam: { name: "Galatasaray", shortName: "GS", logoUrl: "", formLast5: "GGGBG" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-07T20:00:00+03:00")),
        stadium: "Tüpraş Stadyumu", status: "upcoming",
        odds: { home: 3.10, draw: 3.25, away: 2.30, source: "genel" },
        importance: "high",
    },
    {
        homeTeam: { name: "Fenerbahçe", shortName: "FB", logoUrl: "", formLast5: "GGGGB" },
        awayTeam: { name: "Samsunspor", shortName: "SAM", logoUrl: "", formLast5: "MBMGM" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-08T20:00:00+03:00")),
        stadium: "Fenerbahçe Şükrü Saracoğlu Stadyumu", status: "upcoming",
        odds: { home: 1.25, draw: 5.50, away: 11.00, source: "genel" },
        importance: "high",
    },
    {
        homeTeam: { name: "Başakşehir", shortName: "BAS", logoUrl: "", formLast5: "BGMBG" },
        awayTeam: { name: "Göztepe", shortName: "GOZ", logoUrl: "", formLast5: "MGBGM" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-07T16:00:00+03:00")),
        stadium: "Başakşehir Fatih Terim Stadyumu", status: "upcoming",
        odds: { home: 1.85, draw: 3.40, away: 4.50, source: "genel" },
        importance: "normal",
    },
    {
        homeTeam: { name: "Gaziantep FK", shortName: "GFK", logoUrl: "", formLast5: "MMBGM" },
        awayTeam: { name: "Fatih Karagümrük", shortName: "FKG", logoUrl: "", formLast5: "BGMMB" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-08T13:30:00+03:00")),
        stadium: "Gaziantep Stadyumu", status: "upcoming",
        odds: { home: 2.10, draw: 3.20, away: 3.60, source: "genel" },
        importance: "normal",
    },
    {
        homeTeam: { name: "Çaykur Rizespor", shortName: "RIZ", logoUrl: "", formLast5: "MMGBM" },
        awayTeam: { name: "Antalyaspor", shortName: "ANT", logoUrl: "", formLast5: "BGMGB" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-08T13:30:00+03:00")),
        stadium: "Çaykur Didi Stadyumu", status: "upcoming",
        odds: { home: 2.30, draw: 3.10, away: 3.20, source: "genel" },
        importance: "normal",
    },
    {
        homeTeam: { name: "Konyaspor", shortName: "KON", logoUrl: "", formLast5: "MBMBB" },
        awayTeam: { name: "Kasımpaşa", shortName: "KAS", logoUrl: "", formLast5: "MGMBG" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-08T16:00:00+03:00")),
        stadium: "Konya Büyükşehir Stadyumu", status: "upcoming",
        odds: { home: 2.00, draw: 3.30, away: 3.80, source: "genel" },
        importance: "normal",
    },
    {
        homeTeam: { name: "Eyüpspor", shortName: "EYP", logoUrl: "", formLast5: "BMBGM" },
        awayTeam: { name: "Kocaelispor", shortName: "KOC", logoUrl: "", formLast5: "MBMBG" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-09T16:00:00+03:00")),
        stadium: "Recep Tayyip Erdoğan Stadyumu", status: "upcoming",
        odds: { home: 1.95, draw: 3.30, away: 4.00, source: "genel" },
        importance: "normal",
    },
    {
        homeTeam: { name: "Alanyaspor", shortName: "ALN", logoUrl: "", formLast5: "GMMBG" },
        awayTeam: { name: "Gençlerbirliği", shortName: "GEN", logoUrl: "", formLast5: "MBGMM" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-09T20:00:00+03:00")),
        stadium: "Alanya Oba Stadyumu", status: "upcoming",
        odds: { home: 1.70, draw: 3.50, away: 5.00, source: "genel" },
        importance: "normal",
    },
    {
        homeTeam: { name: "Kayserispor", shortName: "KAY", logoUrl: "", formLast5: "MMMBM" },
        awayTeam: { name: "Trabzonspor", shortName: "TS", logoUrl: "", formLast5: "GGBGG" },
        league: "Süper Lig", leagueCountry: "TR", week: 25,
        matchDate: admin.firestore.Timestamp.fromDate(new Date("2026-03-09T20:00:00+03:00")),
        stadium: "RHG Enertürk Enerji Stadyumu", status: "upcoming",
        odds: { home: 4.50, draw: 3.60, away: 1.80, source: "genel" },
        importance: "normal",
    },
];

async function seed() {
    const batch = db.batch();
    const now = admin.firestore.Timestamp.now();

    for (const match of matches) {
        const ref = db.collection("matches").doc();
        batch.set(ref, { ...match, createdAt: now, updatedAt: now });
    }

    await batch.commit();
    console.log(`✅ ${matches.length} maç eklendi!`);
    process.exit(0);
}

seed().catch((e) => { console.error("❌ Hata:", e); process.exit(1); });
