import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Connect
conn = psycopg2.connect(
    dbname="spotify",
    user="postgres",
    password="samar",
    host="localhost"
)

# Load data
df = pd.read_sql("SELECT * FROM spotify_tracks", conn)

# Popularity distribution
# Shows how many songs fall into each popularity range (0–100).
# Helps us understand whether most songs are low, medium, or high popularity.

plt.hist(df["popularity"], bins=30)
plt.title("Popularity Distribution")
plt.xlabel("Popularity")
plt.ylabel("Count")
plt.show()


# Popularity vs Energy Scatter Plot
# This scatter plot shows the relationship between a song's energy level 
# (how intense or powerful it feels) and its popularity score (0–100).

# What this plot helps us understand:
# - Do high-energy songs tend to be more popular?
# - Are low-energy songs less popular?
# - Is there any visible trend or correlation?

# Each dot = one song.
# X-axis = Energy (0 to 1, higher means more intense)
# Y-axis = Popularity (0 to 100, higher means more popular)

# If the dots trend upward, energy and popularity are positively related.
# If they look random, there is no clear relationship.
plt.figure(figsize=(8,5))
plt.scatter(df["energy"], df["popularity"], alpha=0.3)
plt.title("Popularity vs Energy")
plt.xlabel("Energy")
plt.ylabel("Popularity")
plt.show()
#UPDATE
# Interpretation of the Popularity vs Energy scatter plot:
# - There is NO strong visible relationship between energy and popularity.
# - Popular songs (60–100 popularity) appear at ALL energy levels (0.0 to 1.0),
#   which means both calm songs and high-energy songs can become popular.
# - The entire cloud of points looks very horizontal, showing that changes in
#   energy do NOT cause big changes in popularity.
# - We see a very heavy concentration of songs with low popularity (0–20)
#   across all energy values. This is expected because the dataset contains
#   many obscure tracks.
# - There is a slight trend where extremely energetic songs (0.8–1.0) have
#   more tracks with higher popularity, but the pattern is weak.

# Summary:
# Energy alone does not explain popularity. Popular songs come from a wide
# range of energy levels, meaning other features (danceability, valence,
# marketing, artist fame, etc.) likely influence popularity more.
