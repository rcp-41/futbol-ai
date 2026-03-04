# FutbolAI — Güncellenmiş Korelasyon Motoru: Tam Kombinasyonel Tarama

## Temel Felsefe Değişikliği

### Önceki Yaklaşım (Hardcoded)
```
5 adet önceden tanımlanmış korelasyon tipi:
  → "Oyuncu vs stoper hızı"
  → "Takım vs yağmur"
  → "Formasyon vs formasyon"
  → ...
Sorun: Biz hangi korelasyonların önemli olduğunu ÖNCEDEN bildiğimizi varsayıyorduk.
```

### Yeni Yaklaşım (Kombinasyonel Tarama)
```
Sistemdeki TÜM metrikler çaprazlanır:
  → Oyuncunun koşu mesafesi × rakibin pres yoğunluğu
  → Progresif pas sayısı × hava sıcaklığı
  → İkili mücadele kazanma × rakip stoperin boy ortalaması
  → Takımın xG'si × hakemin faul ortalaması
  → ... ve diğer TÜM kombinasyonlar

Bot neyin önemli olduğunu BİLMEZ. Matematiksel olarak anlamlı olan
her şeyi bulur ve raporlar.
```

---

## BÖLÜM 1: Metrik Kataloğu

Taranacak tüm metrikler ve kaynakları. Sistem bunları dinamik olarak çaprazlayacak.

```python
# ═══════════════════════════════════════════════════════════
# METRİK KATALOĞU — Taranacak tüm değişkenler
# ═══════════════════════════════════════════════════════════

PLAYER_METRICS = {
    # Hücum
    "goals":                "Gol sayısı",
    "assists":              "Asist sayısı",
    "xG":                   "Beklenen gol",
    "xA":                   "Beklenen asist",
    "shots":                "Şut sayısı",
    "shotsOnTarget":        "İsabetli şut",
    "shotAccuracy":         "Şut isabet oranı",
    "keyPasses":            "Anahtar pas",
    "progressivePasses":    "Progresif pas",
    "progressiveCarries":   "Progresif top taşıma",
    "passAccuracy":         "Pas isabet oranı",
    "crossAccuracy":        "Orta isabet oranı",
    "throughBalls":          "Ara pas",
    "chancesCreated":       "Yaratılan pozisyon (SCA)",
    "touches":              "Topa dokunma",
    "touchesInBox":         "Ceza alanında dokunma",
    "dribbleSuccess":       "Başarılı çalım oranı",
    "dribbleAttempts":      "Çalım denemesi",

    # Defans
    "tackles":              "Müdahale",
    "tackleSuccess":        "Müdahale başarı oranı",
    "interceptions":        "Top kesme",
    "clearances":           "Uzaklaştırma",
    "blocks":               "Blok",
    "aerialDuelsWon":       "Kazanılan hava topu",
    "aerialDuelsPct":       "Hava topu kazanma oranı",
    "groundDuelsWon":       "Kazanılan ikili mücadele",
    "groundDuelsPct":       "İkili mücadele kazanma oranı",
    "foulsCommitted":       "Yapılan faul",
    "foulsSuffered":        "Kazanılan faul",
    "yellowCards":          "Sarı kart",
    "redCards":             "Kırmızı kart",

    # Fiziksel
    "distanceKm":           "Koşu mesafesi (km)",
    "sprintCount":          "Sprint sayısı",
    "topSpeedKmh":          "Maksimum hız (km/s)",
    "highIntensityRuns":    "Yüksek yoğunluk koşusu",
    "pressures":            "Baskı aksiyonu",
    "pressureSuccess":      "Başarılı baskı oranı",

    # Pas dağılımı
    "longBalls":            "Uzun pas",
    "longBallAccuracy":     "Uzun pas isabeti",
    "shortPassAccuracy":    "Kısa pas isabeti",
    "passesIntoFinalThird": "Son 1/3'e pas",
    "passesIntoBox":        "Ceza alanına pas",
    "backPasses":           "Geri pas",

    # Diğer
    "minutesPlayed":        "Oynanan dakika",
    "ballLosses":           "Top kaybı",
    "ballRecoveries":       "Top geri kazanma",
    "offsides":             "Ofsayt",
    "penaltiesWon":         "Kazanılan penaltı",
}

TEAM_METRICS = {
    # Genel
    "possession":           "Topa sahip olma (%)",
    "xG":                   "Takım xG",
    "xGA":                  "Verilen xG",
    "goalsScored":          "Atılan gol",
    "goalsConceded":        "Yenilen gol",

    # Şut
    "totalShots":           "Toplam şut",
    "shotsOnTarget":        "İsabetli şut",
    "shotsBlocked":         "Bloke edilen şut",
    "bigChancesCreated":    "Büyük pozisyon",
    "bigChancesMissed":     "Kaçırılan büyük pozisyon",

    # Pas
    "passAccuracy":         "Pas isabeti (%)",
    "totalPasses":          "Toplam pas",
    "longBallPct":          "Uzun top oranı (%)",
    "progressivePasses":    "Progresif pas",
    "crossesAttempted":     "Orta sayısı",
    "crossAccuracy":        "Orta isabeti (%)",

    # Defans
    "ppda":                 "PPDA (pres yoğunluğu)",
    "tackles":              "Toplam müdahale",
    "interceptions":        "Toplam kesme",
    "clearances":           "Toplam uzaklaştırma",
    "aerialDuelsWonPct":    "Hava topu kazanma (%)",
    "challengeIntensity":   "Temas yoğunluğu",

    # Fiziksel
    "totalDistanceKm":      "Takım koşu mesafesi",
    "totalSprints":         "Takım sprint sayısı",
    "highPressCount":       "Yüksek baskı sayısı",

    # Disiplin
    "fouls":                "Toplam faul",
    "yellowCards":          "Sarı kart",
    "redCards":             "Kırmızı kart",
    "corners":              "Korner",
    "offsides":             "Ofsayt",
}

CONDITION_METRICS = {
    # Hava
    "temperature":          "Sıcaklık (°C)",
    "humidity":             "Nem (%)",
    "windSpeed":            "Rüzgar (km/s)",
    "rain":                 "Yağış (0=yok, 1=hafif, 2=şiddetli)",
    "pitchCondition":       "Zemin (0=kuru, 1=nemli, 2=ıslak)",

    # Yorgunluk
    "restDays":             "Dinlenme günü",
    "isEuropeanReturn":     "Avrupa dönüşü (0/1)",
    "travelDistanceKm":     "Seyahat mesafesi",
    "matchesInLast14Days":  "Son 14 günde oynanan maç",

    # Hakem
    "refFoulsPerMatch":     "Hakem faul ortalaması",
    "refYellowsPerMatch":   "Hakem sarı kart ortalaması",
    "refRedsPerMatch":      "Hakem kırmızı kart ortalaması",
    "refPenaltyRate":       "Hakem penaltı oranı",

    # Maç bağlamı
    "importance":           "Maç önemi (1=normal, 2=kritik, 3=derbi, 4=final)",
    "isHome":               "Ev sahibi mi (0/1)",
    "dayOfWeek":            "Haftanın günü",
    "kickoffHour":          "Maç saati",

    # Rakip profili (takım seviyesinde)
    "oppPossession":        "Rakip topa sahip olma",
    "oppPpda":              "Rakip PPDA",
    "oppXG":                "Rakip xG",
    "oppFormation":         "Rakip formasyon kodu",
}
```

---

## BÖLÜM 2: Kombinasyonel Tarama Motoru

```python
import numpy as np
from scipy.stats import pearsonr, spearmanr
from itertools import combinations
from google.cloud import firestore
from typing import Optional
import warnings
warnings.filterwarnings("ignore")

db = firestore.Client()


# ═══════════════════════════════════════════════════════════
# VERİ TOPLAMA: Bir takımın/oyuncunun tüm maç verisini
# metrik bazlı düz tabloya çevir
# ═══════════════════════════════════════════════════════════

def build_team_match_matrix(team_id: str, season: str = "2025-26") -> list[dict]:
    """
    Bir takımın tüm maçlarını, TÜM metriklerle birlikte
    düz bir tablo (list of dicts) olarak döndürür.
    Her satır = 1 maç, her kolon = 1 metrik veya koşul.
    """
    matches = db.collection("match_stats") \
        .where("teamId", "==", team_id) \
        .where("season", "==", season) \
        .order_by("date") \
        .stream()

    rows = []
    for doc in matches:
        m = doc.to_dict()
        row = {"matchId": m["matchId"], "date": m["date"]}

        # Takım metrikleri
        for key in TEAM_METRICS:
            row[f"team_{key}"] = m.get(key, None)

        # Koşul metrikleri
        weather = m.get("weather", {})
        row["cond_temperature"] = weather.get("temperature", None)
        row["cond_humidity"] = weather.get("humidity", None)
        row["cond_windSpeed"] = weather.get("windSpeed", None)
        row["cond_rain"] = encode_rain(weather.get("rain", "none"))
        row["cond_pitchCondition"] = encode_pitch(weather.get("pitchCondition", "normal"))

        row["cond_restDays"] = m.get("restDays", None)
        row["cond_isEuropeanReturn"] = 1 if m.get("isEuropeanReturn") else 0
        row["cond_travelDistanceKm"] = m.get("travelDistanceKm", 0)
        row["cond_matchesInLast14Days"] = m.get("matchesInLast14Days", None)

        ref = m.get("referee", {})
        row["cond_refFoulsPerMatch"] = ref.get("foulsPerMatch", None)
        row["cond_refYellowsPerMatch"] = ref.get("yellowsPerMatch", None)
        row["cond_refRedsPerMatch"] = ref.get("redsPerMatch", None)
        row["cond_refPenaltyRate"] = ref.get("penaltyRate", None)

        row["cond_importance"] = encode_importance(m.get("importance", "normal"))
        row["cond_isHome"] = 1 if m.get("venue") == "home" else 0

        # Rakip profili
        opp = m.get("opponent", {})
        row["cond_oppPossession"] = opp.get("possession", None)
        row["cond_oppPpda"] = opp.get("ppda", None)
        row["cond_oppXG"] = opp.get("xG", None)
        row["cond_oppFormation"] = encode_formation(opp.get("formation", "4-4-2"))

        # Sonuç (korelasyonun hedef değişkeni)
        row["result_goalsScored"] = m.get("goalsScored", 0)
        row["result_goalsConceded"] = m.get("goalsConceded", 0)
        row["result_xG"] = m.get("xG", 0)
        row["result_points"] = encode_result(m.get("result", "D"))

        rows.append(row)

    return rows


def build_player_match_matrix(player_id: str, season: str = "2025-26") -> list[dict]:
    """
    Bir oyuncunun tüm maçlarını TÜM metrikleriyle döndürür.
    Rakip oyuncu profilleri de dahil.
    """
    matches = db.collection("player_match_stats") \
        .where("playerId", "==", player_id) \
        .where("season", "==", season) \
        .stream()

    rows = []
    for doc in matches:
        m = doc.to_dict()
        row = {"matchId": m["matchId"], "date": m["date"]}

        # Oyuncu metrikleri
        for key in PLAYER_METRICS:
            row[f"player_{key}"] = m.get(key, None)

        # Maç koşulları
        weather = m.get("weather", {})
        row["cond_temperature"] = weather.get("temperature", None)
        row["cond_humidity"] = weather.get("humidity", None)
        row["cond_windSpeed"] = weather.get("windSpeed", None)
        row["cond_rain"] = encode_rain(weather.get("rain", "none"))
        row["cond_restDays"] = m.get("teamRestDays", None)
        row["cond_isHome"] = 1 if m.get("venue") == "home" else 0
        row["cond_importance"] = encode_importance(m.get("importance", "normal"))

        # Direkt rakip profili (aynı pozisyondaki karşı oyuncu)
        opp = m.get("directOpponent", {})
        row["opp_topSpeedKmh"] = opp.get("topSpeedKmh", None)
        row["opp_height"] = opp.get("height", None)
        row["opp_tackleSuccess"] = opp.get("tackleSuccess", None)
        row["opp_aerialDuelsPct"] = opp.get("aerialDuelsPct", None)
        row["opp_pressures"] = opp.get("pressures", None)
        row["opp_interceptions"] = opp.get("interceptions", None)

        # Rakip takım profili
        row["cond_oppPossession"] = m.get("opponentTeamPossession", None)
        row["cond_oppPpda"] = m.get("opponentTeamPpda", None)

        # Ref profili
        ref = m.get("referee", {})
        row["cond_refYellowsPerMatch"] = ref.get("yellowsPerMatch", None)
        row["cond_refFoulsPerMatch"] = ref.get("foulsPerMatch", None)

        rows.append(row)

    return rows


# ═══════════════════════════════════════════════════════════
# KOMBİNASYONEL TARAMA: Tüm metrik çiftlerini çaprazla
# ═══════════════════════════════════════════════════════════

def scan_all_correlations(
    data_matrix: list[dict],
    entity_name: str,
    entity_type: str,        # "team" veya "player"
    min_sample: int = 5,
    significance_threshold: float = 0.05,
    min_abs_correlation: float = 0.40,
    min_change_pct: float = 15.0,
) -> list[dict]:
    """
    Veri matrisindeki TÜM sayısal kolon çiftlerini tarar.
    İstatistiksel olarak anlamlı korelasyonları döndürür.

    İki tip korelasyon arar:
    A) Sürekli-Sürekli: Pearson/Spearman korelasyonu
       (Örn: rüzgar hızı ↔ uzun pas isabeti)
    B) Kategorik-Sürekli: Grup karşılaştırması
       (Örn: yağmurlu vs kuru maçlarda topa sahip olma)
    """
    correlations = []
    columns = [k for k in data_matrix[0].keys()
               if k not in ("matchId", "date") and not k.startswith("result_")]

    # TİP A: Sürekli-Sürekli korelasyon
    numeric_cols = []
    for col in columns:
        values = [row[col] for row in data_matrix if row[col] is not None]
        if len(values) >= min_sample and all(isinstance(v, (int, float)) for v in values):
            unique = len(set(values))
            if unique > 4:  # Kategorik değil sürekli
                numeric_cols.append(col)

    for col_a, col_b in combinations(numeric_cols, 2):
        corr = compute_correlation(data_matrix, col_a, col_b, min_sample)
        if corr and abs(corr["r"]) >= min_abs_correlation and corr["p"] <= significance_threshold:
            correlations.append({
                "correlationType": "continuous",
                "entity": entity_name,
                "entityType": entity_type,
                "metricA": col_a,
                "metricA_label": get_metric_label(col_a),
                "metricB": col_b,
                "metricB_label": get_metric_label(col_b),
                "r": round(corr["r"], 3),
                "p_value": round(corr["p"], 4),
                "direction": "positive" if corr["r"] > 0 else "negative",
                "sampleSize": corr["n"],
                "interpretation": auto_interpret_continuous(
                    col_a, col_b, corr["r"], entity_name
                ),
                "relevantMatchIds": corr.get("matchIds", []),
                "confidence": compute_confidence(corr["r"], corr["p"], corr["n"]),
            })

    # TİP B: Kategorik-Sürekli (koşul grupları vs performans metrikleri)
    categorical_cols = identify_categorical_columns(data_matrix, columns)
    performance_cols = [c for c in numeric_cols
                        if c.startswith("team_") or c.startswith("player_")
                        or c.startswith("result_")]

    for cat_col in categorical_cols:
        for perf_col in performance_cols:
            group_result = compute_group_comparison(
                data_matrix, cat_col, perf_col, min_sample
            )
            if group_result and abs(group_result["change_pct"]) >= min_change_pct:
                correlations.append({
                    "correlationType": "categorical",
                    "entity": entity_name,
                    "entityType": entity_type,
                    "condition": cat_col,
                    "condition_label": get_metric_label(cat_col),
                    "metric": perf_col,
                    "metric_label": get_metric_label(perf_col),
                    "groupA_label": group_result["groupA_label"],
                    "groupA_avg": round(group_result["groupA_avg"], 2),
                    "groupA_count": group_result["groupA_count"],
                    "groupB_label": group_result["groupB_label"],
                    "groupB_avg": round(group_result["groupB_avg"], 2),
                    "groupB_count": group_result["groupB_count"],
                    "change_pct": round(group_result["change_pct"], 1),
                    "interpretation": auto_interpret_categorical(
                        cat_col, perf_col,
                        group_result["groupA_avg"], group_result["groupB_avg"],
                        entity_name
                    ),
                    "relevantMatchIds": group_result.get("matchIds", []),
                    "confidence": compute_confidence_categorical(
                        group_result["change_pct"],
                        group_result["groupA_count"],
                        group_result["groupB_count"]
                    ),
                })

    # Güven skoruna göre sırala
    correlations.sort(key=lambda x: x["confidence"], reverse=True)
    return correlations


# ═══════════════════════════════════════════════════════════
# MATEMATİKSEL HESAPLAMA FONKSİYONLARI
# ═══════════════════════════════════════════════════════════

def compute_correlation(
    data: list[dict], col_a: str, col_b: str, min_sample: int
) -> Optional[dict]:
    """İki sürekli değişken arasında Spearman korelasyonu hesaplar."""
    pairs = [(row[col_a], row[col_b], row["matchId"])
             for row in data
             if row.get(col_a) is not None and row.get(col_b) is not None]

    if len(pairs) < min_sample:
        return None

    a_vals = [p[0] for p in pairs]
    b_vals = [p[1] for p in pairs]
    match_ids = [p[2] for p in pairs]

    # Spearman: monoton ilişkileri yakalar, Pearson'dan daha sağlam
    r, p = spearmanr(a_vals, b_vals)

    if np.isnan(r):
        return None

    return {"r": r, "p": p, "n": len(pairs), "matchIds": match_ids}


def compute_group_comparison(
    data: list[dict], cat_col: str, perf_col: str, min_sample: int
) -> Optional[dict]:
    """Kategorik değişkene göre gruplara ayır, performans farkını hesapla."""
    # Kategorik kolonu otomatik gruplara böl
    groups = auto_group(data, cat_col)

    if not groups or len(groups) < 2:
        return None

    group_names = list(groups.keys())
    g_a_name, g_b_name = group_names[0], group_names[1]
    g_a_rows = groups[g_a_name]
    g_b_rows = groups[g_b_name]

    g_a_vals = [r[perf_col] for r in g_a_rows if r.get(perf_col) is not None]
    g_b_vals = [r[perf_col] for r in g_b_rows if r.get(perf_col) is not None]

    if len(g_a_vals) < min_sample or len(g_b_vals) < min_sample:
        return None

    avg_a = np.mean(g_a_vals)
    avg_b = np.mean(g_b_vals)

    if avg_a == 0:
        return None

    change = ((avg_b - avg_a) / abs(avg_a)) * 100

    match_ids = [r["matchId"] for r in g_b_rows if r.get(perf_col) is not None]

    return {
        "groupA_label": g_a_name,
        "groupA_avg": avg_a,
        "groupA_count": len(g_a_vals),
        "groupB_label": g_b_name,
        "groupB_avg": avg_b,
        "groupB_count": len(g_b_vals),
        "change_pct": change,
        "matchIds": match_ids,
    }


def auto_group(data: list[dict], col: str) -> Optional[dict]:
    """
    Bir kolonu otomatik olarak anlamlı gruplara böler.
    Kategorik ise direkt gruplar, sürekli ise medyan split.
    """
    values = [(row, row.get(col)) for row in data if row.get(col) is not None]
    if not values:
        return None

    sample_val = values[0][1]

    # Zaten kategorik (string veya 0/1)
    if isinstance(sample_val, str):
        groups = {}
        for row, val in values:
            groups.setdefault(val, []).append(row)
        return groups if len(groups) >= 2 else None

    # Boolean-like (0/1)
    unique_vals = set(v for _, v in values)
    if unique_vals <= {0, 1}:
        return {
            "hayır": [r for r, v in values if v == 0],
            "evet": [r for r, v in values if v == 1],
        }

    # Sürekli → medyan split
    nums = [v for _, v in values]
    median = np.median(nums)

    # Anlamlı isimler oluştur
    col_label = get_metric_label(col)
    return {
        f"{col_label} düşük (≤{median:.1f})": [r for r, v in values if v <= median],
        f"{col_label} yüksek (>{median:.1f})": [r for r, v in values if v > median],
    }


def identify_categorical_columns(data: list[dict], columns: list[str]) -> list[str]:
    """Kategorik veya ikili (0/1) kolonları tespit eder."""
    categorical = []
    for col in columns:
        values = [row[col] for row in data if row[col] is not None]
        if not values:
            continue
        if isinstance(values[0], str):
            categorical.append(col)
            continue
        unique = set(values)
        if unique <= {0, 1}:
            categorical.append(col)
            continue
        # Az sayıda unique değer varsa sürekli ama gruplanabilir
        if len(unique) <= 6 and all(isinstance(v, (int, float)) for v in values):
            categorical.append(col)

    # Sürekli koşul metriklerini de ekle (medyan split yapılacak)
    for col in columns:
        if col.startswith("cond_") and col not in categorical:
            values = [row[col] for row in data if row[col] is not None]
            if len(values) >= 10 and all(isinstance(v, (int, float)) for v in values):
                categorical.append(col)

    return categorical


# ═══════════════════════════════════════════════════════════
# OTOMATİK YORUMLAMA (AI'a gidecek insan-okunur metinler)
# ═══════════════════════════════════════════════════════════

def auto_interpret_continuous(
    col_a: str, col_b: str, r: float, entity: str
) -> str:
    label_a = get_metric_label(col_a)
    label_b = get_metric_label(col_b)
    direction = "arttığında artıyor" if r > 0 else "arttığında düşüyor"
    strength = "güçlü" if abs(r) > 0.65 else "orta"
    return (
        f"{entity}: {label_a} {direction} → {label_b} "
        f"({strength} ilişki, r={r:.2f})"
    )


def auto_interpret_categorical(
    cat_col: str, perf_col: str,
    avg_a: float, avg_b: float, entity: str
) -> str:
    cat_label = get_metric_label(cat_col)
    perf_label = get_metric_label(perf_col)
    change = ((avg_b - avg_a) / abs(avg_a)) * 100
    direction = "artıyor" if change > 0 else "düşüyor"
    return (
        f"{entity}: {cat_label} değiştiğinde {perf_label} "
        f"%{abs(change):.0f} {direction} ({avg_a:.1f} → {avg_b:.1f})"
    )


def compute_confidence(r: float, p: float, n: int) -> float:
    """Korelasyon gücü + p-value + örneklem büyüklüğüne göre güven skoru."""
    r_score = min(abs(r) / 0.8, 1.0)         # r=0.8 → tam puan
    p_score = max(1.0 - (p / 0.05), 0.0)     # p=0 → tam puan
    n_score = min(n / 15, 1.0)                # n=15+ → tam puan
    return round(r_score * 0.4 + p_score * 0.3 + n_score * 0.3, 2)


def compute_confidence_categorical(change_pct: float, n_a: int, n_b: int) -> float:
    """Kategorik korelasyon güven skoru."""
    change_score = min(abs(change_pct) / 40, 1.0)
    sample_score = min(min(n_a, n_b) / 8, 1.0)
    return round(change_score * 0.5 + sample_score * 0.5, 2)


def get_metric_label(col: str) -> str:
    """Kolon adından insan-okunur etiket üret."""
    clean = col.replace("team_", "").replace("player_", "") \
               .replace("cond_", "").replace("opp_", "rakip ")  \
               .replace("result_", "sonuç:")

    # Kataloglardan bul
    for catalog in [PLAYER_METRICS, TEAM_METRICS, CONDITION_METRICS]:
        if clean in catalog:
            return catalog[clean]

    return clean


def encode_rain(val: str) -> int:
    return {"none": 0, "light": 1, "heavy": 2}.get(val, 0)

def encode_pitch(val: str) -> int:
    return {"dry": 0, "normal": 0, "wet": 1, "frozen": 2}.get(val, 0)

def encode_importance(val: str) -> int:
    return {"normal": 1, "important": 2, "derby": 3, "final": 4,
            "relegation": 3, "title_decider": 4}.get(val, 1)

def encode_formation(val: str) -> int:
    formations = {"4-4-2": 1, "4-3-3": 2, "4-2-3-1": 3, "3-5-2": 4,
                  "3-4-3": 5, "5-3-2": 6, "5-4-1": 7, "4-1-4-1": 8}
    return formations.get(val, 0)

def encode_result(val: str) -> int:
    return {"W": 3, "D": 1, "L": 0}.get(val, 1)


# ═══════════════════════════════════════════════════════════
# RELEVANSI FİLTRESİ: Önümüzdeki maça uygun korelasyonları seç
# ═══════════════════════════════════════════════════════════

def filter_relevant_correlations(
    correlations: list[dict],
    upcoming_conditions: dict,
) -> list[dict]:
    """
    Tüm bulunan korelasyonlardan, ÖNÜMÜZDEKI MAÇA UYGUN
    olanları filtreler.

    Örnek: "Yağmurda topa sahip olma düşüyor" korelasyonu
    bulunmuş olabilir ama yarınki maçta hava açıksa
    bu korelasyon GEÇERSİZ → filtrele.
    """
    relevant = []

    for corr in correlations:
        if corr["correlationType"] == "categorical":
            cond = corr["condition"]

            # Hava korelasyonu → yarın hava benzer mi?
            if "rain" in cond:
                upcoming_rain = upcoming_conditions.get("rain", 0)
                if "yüksek" in corr.get("groupB_label", "") and upcoming_rain >= 1:
                    relevant.append(corr)
                elif "düşük" in corr.get("groupB_label", "") and upcoming_rain == 0:
                    relevant.append(corr)
                continue

            if "temperature" in cond:
                upcoming_temp = upcoming_conditions.get("temperature", 20)
                group_b = corr.get("groupB_label", "")
                # "Sıcaklık yüksek" korelasyonu + yarın sıcak → ilgili
                if "yüksek" in group_b and upcoming_temp > 25:
                    relevant.append(corr)
                elif "düşük" in group_b and upcoming_temp < 10:
                    relevant.append(corr)
                continue

            if "restDays" in cond:
                upcoming_rest = upcoming_conditions.get("restDays", 5)
                if "düşük" in corr.get("groupB_label", "") and upcoming_rest <= 3:
                    relevant.append(corr)
                elif "yüksek" in corr.get("groupB_label", "") and upcoming_rest > 3:
                    relevant.append(corr)
                continue

            if "oppPpda" in cond or "oppPossession" in cond or "oppFormation" in cond:
                # Rakip profili korelasyonları her zaman ilgili
                relevant.append(corr)
                continue

            if "ref" in cond:
                # Hakem korelasyonları her zaman ilgili
                relevant.append(corr)
                continue

            if "importance" in cond:
                upcoming_imp = upcoming_conditions.get("importance", 1)
                if "yüksek" in corr.get("groupB_label", "") and upcoming_imp >= 3:
                    relevant.append(corr)
                continue

            # Diğer kategorik korelasyonlar (ev/deplasman, haftanın günü vb.)
            relevant.append(corr)

        elif corr["correlationType"] == "continuous":
            # Sürekli korelasyonlar her zaman potansiyel olarak ilgili
            # (Çünkü "xG arttıkça gol atma da artıyor" her maçta geçerli)
            relevant.append(corr)

    return relevant


# ═══════════════════════════════════════════════════════════
# ANA ORKESTRASYON
# ═══════════════════════════════════════════════════════════

def run_full_combinatorial_scan(
    home_team_id: str,
    away_team_id: str,
    match_id: str,
    upcoming_conditions: dict,
    season: str = "2025-26",
) -> dict:
    """
    Tam kombinasyonel tarama:
    1. Her iki takımın tüm maçlarını metrik matrisine çevir
    2. Her iki takımın kilit oyuncuları için aynısını yap
    3. Tüm metrik çiftlerini çaprazla
    4. Önümüzdeki maça uygun olanları filtrele
    """
    all_correlations = []

    # ─── Takım seviyesi tarama ────────────────────────
    home_matrix = build_team_match_matrix(home_team_id, season)
    away_matrix = build_team_match_matrix(away_team_id, season)

    home_team_corrs = scan_all_correlations(
        home_matrix, home_team_id, "team"
    )
    away_team_corrs = scan_all_correlations(
        away_matrix, away_team_id, "team"
    )

    all_correlations.extend(home_team_corrs)
    all_correlations.extend(away_team_corrs)

    # ─── Oyuncu seviyesi tarama ───────────────────────
    home_key_players = get_team_key_players(home_team_id)
    away_key_players = get_team_key_players(away_team_id)

    for player in home_key_players + away_key_players:
        player_matrix = build_player_match_matrix(player["id"], season)
        if len(player_matrix) >= 5:  # Yeterli veri varsa
            player_corrs = scan_all_correlations(
                player_matrix, player["name"], "player"
            )
            all_correlations.extend(player_corrs)

    # ─── Relevansı filtrele ───────────────────────────
    relevant = filter_relevant_correlations(all_correlations, upcoming_conditions)

    # ─── Sırala ve döndür ─────────────────────────────
    relevant.sort(key=lambda x: x["confidence"], reverse=True)

    return {
        "matchId": match_id,
        "homeTeam": home_team_id,
        "awayTeam": away_team_id,
        "scanStats": {
            "totalCorrelationsScanned": count_total_pairs(home_matrix, away_matrix),
            "significantFound": len(all_correlations),
            "relevantToUpcoming": len(relevant),
            "teamLevelFindings": len(home_team_corrs) + len(away_team_corrs),
            "playerLevelFindings": len(all_correlations) - len(home_team_corrs) - len(away_team_corrs),
        },
        "correlations": relevant[:50],  # En güçlü 50 bulguyu AI'a gönder
        "highConfidence": [c for c in relevant if c["confidence"] >= 0.70],
        "mediumConfidence": [c for c in relevant if 0.40 <= c["confidence"] < 0.70],
        "lowConfidence": [c for c in relevant if c["confidence"] < 0.40],
    }


def count_total_pairs(home_matrix, away_matrix) -> int:
    """Taranan toplam kombinasyon sayısı."""
    home_cols = len([k for k in home_matrix[0] if k not in ("matchId", "date")])
    away_cols = len([k for k in away_matrix[0] if k not in ("matchId", "date")])
    from math import comb
    return comb(home_cols, 2) + comb(away_cols, 2)


def get_team_key_players(team_id: str) -> list[dict]:
    """İlk 11 + en çok süre alan 3 yedek = taranacak oyuncular."""
    players = db.collection("players") \
        .where("teamId", "==", team_id) \
        .order_by("minutesPlayed", direction="DESCENDING") \
        .limit(14) \
        .stream()
    return [doc.to_dict() for doc in players]
```

---

## BÖLÜM 3: Örnek Tarama Çıktısı

Bir Galatasaray-Fenerbahçe maçı için botun üretebileceği çıktı:

```json
{
  "matchId": "gs-fb-2026-03-24",
  "homeTeam": "Galatasaray",
  "awayTeam": "Fenerbahce",
  "scanStats": {
    "totalCorrelationsScanned": 12846,
    "significantFound": 67,
    "relevantToUpcoming": 23,
    "teamLevelFindings": 14,
    "playerLevelFindings": 53
  },
  "highConfidence": [
    {
      "correlationType": "categorical",
      "entity": "Galatasaray",
      "entityType": "team",
      "condition": "cond_rain",
      "condition_label": "Yağış",
      "metric": "team_possession",
      "metric_label": "Topa sahip olma (%)",
      "groupA_label": "Yağış düşük (≤0.0)",
      "groupA_avg": 62.3,
      "groupA_count": 18,
      "groupB_label": "Yağış yüksek (>0.0)",
      "groupB_avg": 47.8,
      "groupB_count": 7,
      "change_pct": -23.3,
      "interpretation": "Galatasaray: Yağış değiştiğinde Topa sahip olma (%) %23 düşüyor (62.3 → 47.8)",
      "confidence": 0.82
    },
    {
      "correlationType": "continuous",
      "entity": "Icardi",
      "entityType": "player",
      "metricA": "opp_topSpeedKmh",
      "metricA_label": "rakip Maksimum hız (km/s)",
      "metricB": "player_ballLosses",
      "metricB_label": "Top kaybı",
      "r": 0.72,
      "p_value": 0.003,
      "direction": "positive",
      "sampleSize": 14,
      "interpretation": "Icardi: rakip Maksimum hız (km/s) arttığında artıyor → Top kaybı (güçlü ilişki, r=0.72)",
      "confidence": 0.78
    },
    {
      "correlationType": "categorical",
      "entity": "Galatasaray",
      "entityType": "team",
      "condition": "cond_oppFormation",
      "condition_label": "Rakip formasyon kodu",
      "metric": "result_xG",
      "metric_label": "sonuç:xG",
      "groupA_label": "Diğer formasyonlar",
      "groupA_avg": 2.1,
      "groupA_count": 20,
      "groupB_label": "3-5-2 karşısı",
      "groupB_avg": 0.8,
      "groupB_count": 4,
      "change_pct": -61.9,
      "interpretation": "Galatasaray: 3-5-2 formasyonuna karşı sonuç:xG %62 düşüyor (2.1 → 0.8)",
      "confidence": 0.75
    },
    {
      "correlationType": "continuous",
      "entity": "Fenerbahce",
      "entityType": "team",
      "metricA": "cond_restDays",
      "metricA_label": "Dinlenme günü",
      "metricB": "team_totalSprints",
      "metricB_label": "Takım sprint sayısı",
      "r": 0.68,
      "p_value": 0.008,
      "direction": "positive",
      "sampleSize": 12,
      "interpretation": "Fenerbahce: Dinlenme günü arttığında artıyor → Takım sprint sayısı (güçlü ilişki, r=0.68)",
      "confidence": 0.71
    }
  ],
  "mediumConfidence": [
    {
      "correlationType": "categorical",
      "entity": "Galatasaray",
      "entityType": "team",
      "condition": "cond_refYellowsPerMatch",
      "condition_label": "Hakem sarı kart ortalaması",
      "metric": "team_fouls",
      "metric_label": "Toplam faul",
      "groupA_label": "Hakem sarı kart ortalaması düşük (≤4.0)",
      "groupA_avg": 12.1,
      "groupA_count": 14,
      "groupB_label": "Hakem sarı kart ortalaması yüksek (>4.0)",
      "groupB_avg": 16.8,
      "groupB_count": 8,
      "change_pct": 38.8,
      "interpretation": "Galatasaray: Hakem sarı kart ortalaması değiştiğinde Toplam faul %39 artıyor (12.1 → 16.8)",
      "confidence": 0.58
    },
    {
      "correlationType": "continuous",
      "entity": "Icardi",
      "entityType": "player",
      "metricA": "cond_temperature",
      "metricA_label": "Sıcaklık (°C)",
      "metricB": "player_distanceKm",
      "metricB_label": "Koşu mesafesi (km)",
      "r": -0.54,
      "p_value": 0.032,
      "direction": "negative",
      "sampleSize": 16,
      "interpretation": "Icardi: Sıcaklık (°C) arttığında düşüyor → Koşu mesafesi (km) (orta ilişki, r=-0.54)",
      "confidence": 0.49
    }
  ]
}
```

---

## BÖLÜM 4: Güncellenen Mimari Kurallar

### Kaldırılan: Kolay Maç Bypass

Her maç, korelasyon taraması dahil tam pipeline'dan geçer.
Net favori maçlarda bile korelasyon motoru beklenmedik riskler bulabilir.

```
❌ Kaldırıldı:
function shouldUseEnsemble(matchData) { ... }

✅ Yeni kural:
Her maç → Python korelasyon taraması → 3 kanal → Sentezci
İstisna yok.
```

### Güncellenen Maliyet (Bypass Olmadan)

```
Her maç = tam pipeline:
  Python botu:                $0.00 (kendi sunucusu)
  Kanal 1 (Gemini 3.1 Pro):  ~$0.023
  Kanal 2a (GPT-5.2 medium): ~$0.011
  Kanal 2b (GPT-5.2 low):    ~$0.010
  Sentezci (Opus 4.6):       ~$0.040

Maç başı:                     ~$0.084
Günde 30 maç:                 ~$2.52/gün
Aylık (30 gün):               ~$75.60/ay
Cache optimizasyonuyla:       ~$55/ay
```

### Performans Notu

Kombinasyonel tarama binlerce çift tarıyor. Python botu potansiyel
olarak 10.000+ çift kontrol edecek. Bu CPU-yoğun ama:
- Cloud Function yerine Cloud Run veya ayrı bir compute instance
  kullanılabilir (30sn+ sürebilir)
- NumPy/SciPy vektörize işlemler kullandığı için 10K çift ~2-5sn
- Sonuçlar Firestore'da cache'lenebilir (aynı maç tekrar taranmaz)