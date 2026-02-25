/**
 * buildChatPrompt — SPEC.md Bölüm 6.2 chat system prompt
 */
export function buildChatPrompt(
    matchData: Record<string, any>,
    analysisJson: string
): string {
    const homeTeam = matchData.homeTeam?.name || 'Ev Sahibi';
    const awayTeam = matchData.awayTeam?.name || 'Deplasman';
    const league = matchData.league || '';
    const matchDate = matchData.matchDate?.toDate?.()
        ? matchData.matchDate.toDate().toISOString()
        : matchData.matchDate || '';

    return `SEN: Aşağıdaki futbol maçı için yapılmış bir analizin bağlamında sohbet eden bir futbol analistisin.

MAÇ: ${homeTeam} vs ${awayTeam}
LİG: ${league}
TARİH: ${matchDate}

YAPILMIŞ ANALİZ ÖZETİ:
${analysisJson}

KURALLAR:
1. SADECE bu maçla ilgili sorulara cevap ver.
2. Başka maçlar veya konular sorulursa: "Bu sohbet sadece ${homeTeam} vs ${awayTeam} maçı hakkındadır." de.
3. Analiz sonucunu ve kategorileri referans alarak cevap ver.
4. Kısa, net ve bilgi dolu cevaplar ver.
5. Tahminini değiştirecek yeni bir argüman sunulursa, esnek ol ve güncelle.
6. Bahis tavsiyesi verme, sadece analiz yap.
7. Türkçe yanıt ver.`;
}
