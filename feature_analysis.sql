-- FEATURE ANALYSIS SQL MODULE
-- This file contains advanced analytical queries exploring
-- audio features, popularity relationships, and overall insights

-- 1. Average values of key audio features across all tracks

SELECT
    AVG(popularity) AS avg_popularity,
    AVG(danceability) AS avg_danceability,
    AVG(energy) AS avg_energy,
    AVG(tempo) AS avg_tempo,
    AVG(loudness) AS avg_loudness,
    AVG(valence) AS avg_valence
FROM spotify_tracks;


-- 2. Audio features for HIGH popularity songs (>80)

SELECT
    AVG(danceability) AS highpop_danceability,
    AVG(energy) AS highpop_energy,
    AVG(tempo) AS highpop_tempo,
    AVG(loudness) AS highpop_loudness,
    AVG(valence) AS highpop_valence
FROM spotify_tracks
WHERE popularity > 80;

--
-- 3. Audio features for LOW popularity songs (<30)

SELECT
    AVG(danceability) AS lowpop_danceability,
    AVG(energy) AS lowpop_energy,
    AVG(tempo) AS lowpop_tempo,
    AVG(loudness) AS lowpop_loudness,
    AVG(valence) AS lowpop_valence
FROM spotify_tracks
WHERE popularity < 30;


-- 4. Compare feature distributions by popularity bucket

SELECT
    CASE
        WHEN popularity >= 80 THEN 'High'
        WHEN popularity >= 50 THEN 'Medium'
        ELSE 'Low'
    END AS popularity_group,
    AVG(danceability) AS avg_danceability,
    AVG(energy) AS avg_energy,
    AVG(tempo) AS avg_tempo,
    AVG(loudness) AS avg_loudness,
    AVG(valence) AS avg_valence
FROM spotify_tracks
GROUP BY popularity_group
ORDER BY popularity_group;


-- 5. Top 20 most energetic songs

SELECT track_name, artists, energy
FROM spotify_tracks
ORDER BY energy DESC
LIMIT 20;


-- 6. Top 20 most danceable songs

SELECT track_name, artists, danceability
FROM spotify_tracks
ORDER BY danceability DESC
LIMIT 20;


-- 7. Top "sad" (low valence) songs

SELECT track_name, artists, valence
FROM spotify_tracks
ORDER BY valence ASC
LIMIT 20;


-- 8. Loudest tracks

SELECT track_name, artists, loudness
FROM spotify_tracks
ORDER BY loudness DESC
LIMIT 20;


-- 9. Relationship: popularity vs energy (sample overview)

SELECT
    popularity,
    ROUND(energy::numeric, 2) AS energy
FROM spotify_tracks
ORDER BY popularity DESC
LIMIT 100;


-- 10. Popularity grouped by danceability ranges

SELECT
    CASE
        WHEN danceability >= 0.8 THEN 'Very High'
        WHEN danceability >= 0.6 THEN 'High'
        WHEN danceability >= 0.4 THEN 'Medium'
        ELSE 'Low'
    END AS danceability_range,
    AVG(popularity) AS avg_popularity
FROM spotify_tracks
GROUP BY danceability_range
ORDER BY avg_popularity DESC;


-- 11. Popularity by tempo ranges

SELECT
    CASE
        WHEN tempo >= 150 THEN 'Fast'
        WHEN tempo >= 110 THEN 'Moderate'
        ELSE 'Slow'
    END AS tempo_category,
    AVG(popularity) AS avg_popularity
FROM spotify_tracks
GROUP BY tempo_category
ORDER BY avg_popularity DESC;

-- 12. Identify potential "clusters" of songs using features

SELECT
    track_name,
    artists,
    danceability,
    energy,
    valence
FROM spotify_tracks
ORDER BY danceability DESC, energy DESC
LIMIT 50;


-- 13. Most balanced songs (energy + danceability + valence close to mid-range)

SELECT
    track_name,
    artists,
    energy,
    danceability,
    valence,
    ABS(energy - 0.5) + ABS(danceability - 0.5) + ABS(valence - 0.5) AS balance_score
FROM spotify_tracks
ORDER BY balance_score ASC
LIMIT 20;


-- 14. Feature summary by artist (only artists with 20+ tracks)

SELECT
    artists,
    COUNT(*) AS num_tracks,
    AVG(popularity) AS avg_popularity,
    AVG(energy) AS avg_energy,
    AVG(danceability) AS avg_danceability
FROM spotify_tracks
GROUP BY artists
HAVING COUNT(*) >= 20
ORDER BY avg_popularity DESC;


-- 15. Track density per tempo range

SELECT
    CASE
        WHEN tempo < 90 THEN 'Slow'
        WHEN tempo < 130 THEN 'Medium'
        ELSE 'Fast'
    END AS tempo_band,
    COUNT(*) AS num_tracks
FROM spotify_tracks
GROUP BY tempo_band
ORDER BY num_tracks DESC;
