
-- Purpose: Initial exploration of the Spotify dataset.
-- Includes: schema check, basic counts, min/max, simple aggregates.

-- 1. Check the table structure
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'spotify_tracks';


-- 2. Count total rows
SELECT COUNT(*) AS total_tracks
FROM spotify_tracks;


-- 3. Count distinct artists
SELECT COUNT(DISTINCT artists) AS num_artists
FROM spotify_tracks;


-- 4. Range checks for important numeric fields
SELECT
    MIN(popularity) AS min_popularity,
    MAX(popularity) AS max_popularity,
    MIN(tempo) AS min_tempo,
    MAX(tempo) AS max_tempo,
    MIN(duration_ms) AS min_duration_ms,
    MAX(duration_ms) AS max_duration_ms
FROM spotify_tracks;


-- 5. Average values of common audio features
SELECT
    AVG(danceability) AS avg_danceability,
    AVG(energy) AS avg_energy,
    AVG(valence) AS avg_valence,
    AVG(tempo) AS avg_tempo
FROM spotify_tracks;


-- 6. Distribution of popularity (binned)
SELECT
    CASE
        WHEN popularity BETWEEN 0 AND 20 THEN '0-20'
        WHEN popularity BETWEEN 21 AND 40 THEN '21-40'
        WHEN popularity BETWEEN 41 AND 60 THEN '41-60'
        WHEN popularity BETWEEN 61 AND 80 THEN '61-80'
        ELSE '81-100'
    END AS popularity_range,
    COUNT(*) AS track_count
FROM spotify_tracks
GROUP BY popularity_range
ORDER BY popularity_range;



-- 7. Top 10 longest tracks
SELECT track_name, artists, duration_ms
FROM spotify_tracks
ORDER BY duration_ms DESC
LIMIT 10;


-- 8. Top 10 shortest tracks
SELECT track_name, artists, duration_ms
FROM spotify_tracks
ORDER BY duration_ms ASC
LIMIT 10;


-- 9. Check for missing values 
SELECT
    SUM(CASE WHEN artists IS NULL THEN 1 ELSE 0 END) AS null_artists,
    SUM(CASE WHEN track_name IS NULL THEN 1 ELSE 0 END) AS null_track_name,
    SUM(CASE WHEN popularity IS NULL THEN 1 ELSE 0 END) AS null_popularity,
    SUM(CASE WHEN tempo IS NULL THEN 1 ELSE 0 END) AS null_tempo
FROM spotify_tracks;
