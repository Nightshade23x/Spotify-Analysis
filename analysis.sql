

--intermediate analysis
select  DISTINCT track_name, artists, popularity
from spotify_tracks
where popularity > 90
and danceability > 0.8
and explicit = 'False'
order by popularity desc;

--window func
SELECT *
FROM (
    SELECT
        track_name,
        artists,
        track_genre,       -- ADD THIS
        popularity,
        row_number() OVER (
            PARTITION BY track_genre
            ORDER BY popularity DESC
        ) AS genre_rank
    FROM spotify_tracks
) ranked
WHERE genre_rank <= 3
ORDER BY track_genre, genre_rank;
