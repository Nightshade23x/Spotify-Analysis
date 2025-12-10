--window function lets one look at a row and at other rows related to it at the same time
-- Purpose: Learn and demonstrate WINDOW FUNCTIONS.

-- 1. Rank songs globally by popularity
-- RANK() gives the most popular song rank = 1.
-- If two songs have same popularity, they get SAME rank.

SELECT
    track_name,
    artists,
    popularity,
    RANK() OVER (
        ORDER BY popularity DESC
    ) AS popularity_rank
FROM spotify_tracks
ORDER BY popularity DESC
LIMIT 20;

-- 2. Rank songs WITHIN EACH ARTIST
-- PARTITION BY means "group by artist", BUT we don't collapse rows.
-- ROW_NUMBER() gives 1,2,3... with no ties.

SELECT
    artists,
    track_name,
    popularity,
    ROW_NUMBER() OVER (
        PARTITION BY artists
        ORDER BY popularity DESC
    ) AS rank_within_artist
FROM spotify_tracks
ORDER BY artists, rank_within_artist;

-- 3. Get TOP 3 SONGS for each artist
-- We reuse ROW_NUMBER() and then filter rn <= 3.

SELECT *
FROM (
    SELECT
        artists,
        track_name,
        popularity,
        ROW_NUMBER() OVER (
            PARTITION BY artists
            ORDER BY popularity DESC
        ) AS rn
    FROM spotify_tracks
) ranked
WHERE rn <= 3
ORDER BY artists, rn;

-- 4. Moving average of tempo
-- AVG(...) OVER(...) calculates a rolling/ moving average.
-- ROWS BETWEEN 4 PRECEDING AND CURRENT ROW = look at 5 rows at a time.

SELECT
    track_name,
    tempo,
    duration_ms,
    AVG(tempo) OVER (
        ORDER BY duration_ms
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS moving_avg_tempo
FROM spotify_tracks
ORDER BY duration_ms
LIMIT 20;

-- 5. Percentile ranking of popularity
-- PERCENT_RANK() gives a value between 0 and 1.
-- 1 = most popular track in dataset
-- 0 = least popular

SELECT
    track_name,
    artists,
    popularity,
    PERCENT_RANK() OVER (
        ORDER BY popularity
    ) AS popularity_percentile
FROM spotify_tracks
ORDER BY popularity_percentile DESC
LIMIT 20;

-- 6. DENSE_RANK() on danceability
-- Similar to RANK(), but it does NOT skip ranking numbers when ties occur.

SELECT
    track_name,
    artists,
    danceability,
    DENSE_RANK() OVER (
        ORDER BY danceability DESC
    ) AS dance_rank
FROM spotify_tracks
ORDER BY dance_rank
LIMIT 20;

-- 7. Running total of songs per artist
-- COUNT(*) OVER(...) keeps rows and adds a running count.
-- UNBOUNDED PRECEDING = start from the first row for that artist.

SELECT
    artists,
    track_name,
    COUNT(*) OVER (
        PARTITION BY artists
        ORDER BY track_name
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_songs
FROM spotify_tracks
ORDER BY artists, running_total_songs;

-- 8. Compare each song to the artist’s average popularity
-- AVG(popularity) OVER(PARTITION BY artist) = avg pop for that artist.

SELECT
    artists,
    track_name,
    popularity,
    AVG(popularity) OVER (
        PARTITION BY artists
    ) AS artist_avg_popularity,
    popularity -
        AVG(popularity) OVER (PARTITION BY artists)
        AS diff_from_avg
FROM spotify_tracks
ORDER BY diff_from_avg DESC;
