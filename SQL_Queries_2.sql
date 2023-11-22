--
-- Query 1
-- How many different title_types are there? How many of each?
SELECT T.title_type, COUNT(*)
FROM Titles AS T
GROUP BY T.title_type
ORDER BY T.title_type ASC;
--
-- Query 2
-- How many different professions are there? What are they?
SELECT P.job_category, COUNT(*)
FROM Principals AS P
GROUP BY P.job_category
ORDER BY P.job_category ASC;
--
-- Query 3
-- What genres are there? How many movies are there in each genre?
SELECT G.genre, COUNT(G.genre) AS Count
FROM Title_genres AS G, Titles AS T
WHERE T.title_id = G.title_id
AND T.title_type = 'movie'
GROUP BY genre
ORDER BY Count DESC;
--
-- Query 4
-- List movies (runtime_minutes, title_type, primary_title) which are
-- longer than 10 hours. Place them in descending ordering of runtime_minutes.
SELECT runtime_minutes, title_type, primary_title
FROM Titles WHERE runtime_minutes > (10*60)
ORDER BY runtime_minutes DESC, title_type ASC
LIMIT 10;
--
--
-- Query 6
-- How many movies are there in the database?
-- SELECT COUNT(DISTINCT T.title_id) AS Number_of_movies
-- FROM Titles AS T
-- WHERE T.title_type IN ('movie','video');
--
-- Query 7
-- What time period does the database cover?
SELECT LEAST(MIN(T.start_year), MIN(T.end_year)) AS Earliest,
GREATEST(MAX(T.start_year), MAX(T.end_year)) AS Latest
FROM Titles AS T;
--
-- Query 8
-- How many movies where made each year over the past 30 years? (Up to and
-- including 2019)
SELECT T.start_year, COUNT(*) AS  Number_of_movies
FROM Titles AS T
WHERE T.title_type IN ('movie','video')
GROUP BY T.start_year
HAVING T.start_year BETWEEN 1990 AND 2019
ORDER BY T.start_year ASC;
--
-- Query 9
-- Who are the actors who played James Bond in a movie? How many times did they
-- play the role of James Bond?
SELECT N.name_id, N.name_, COUNT(*) AS number_of_films
FROM Names_ AS N, Had_role AS H, Titles AS T
WHERE H.role_ LIKE 'James Bond'
AND T.title_type LIKE 'movie'
AND T.title_id = H.title_id
AND N.name_id = H.name_id
GROUP BY N.name_id;
--
-- Query 12
-- Find all the movies made by Don "The Dragon" Wilson, the former light heavy
-- weight kickboxing champion. He was born in 1954 and is famous for the
-- Bloodfist series. Omit entries where he appears as himself. Output the start
-- year, the title type, title and the role he played. Order these by year.
SELECT DISTINCT T.start_year, T.title_type, T.primary_title, H.role_
FROM Titles AS T, Had_role AS H
WHERE T.title_id = H.title_id
AND H.role_ <> 'Himself'
AND T.title_type IN ('movie','video')
AND H.name_id = (
  SELECT N.name_id
  FROM Names_ AS N
  WHERE N.name_ LIKE 'Don Wilson' AND N.birth_year = 1954)
ORDER BY T.start_year ASC;
--
-- Query 15
-- What are the top 250 movies as determined by the average rating with the over
-- 100,000 votes?
SELECT T.title_id, T.primary_title, R.average_rating
FROM Titles AS T, Title_ratings AS R
WHERE T.title_id = R.title_id
AND T.title_type = 'movie'
AND R.num_votes > 100000
ORDER BY R.average_rating DESC
LIMIT 250;
-- Query 17
-- List all actor names and their roles who starred in the movie Back to the
-- future
SELECT N.name_, H.role_
FROM Titles AS T, Had_role AS H, Names_ AS N
WHERE T.primary_title LIKE 'Back to the Future'
AND T.title_type LIKE 'movie'
AND T.title_id = H.title_id
AND H.name_id = N.name_id;
--
-- Query 18
-- What are the average ratings of the entire back to the future series?
SELECT T.primary_title, R.average_rating
FROM Titles AS T, Title_ratings AS R
WHERE T.primary_title REGEXP '^Back to the Future.*'
AND T.title_id = R.title_id
AND T.title_type = 'movie';
--
-- Query 19
-- What are the average ratings of the entire Trancers series?
SELECT T.primary_title, R.average_rating
FROM Titles AS T, Title_ratings AS R
WHERE T.primary_title REGEXP '^Trancers.*'
AND T.title_id = R.title_id
AND T.title_type IN ('movie','video');
--
-- Query 20
-- How many horror movies are made in leap years>? (~start_year divisible by 4)
SELECT T.start_year, COUNT(DISTINCT T.title_id) AS Number_of_horror_movies
FROM Titles AS T, Title_genres AS G
WHERE T.title_id = G.title_id
AND G.genre = 'Horror'
AND T.title_type IN ('movie','video')
AND (T.start_year % 4) = 0
GROUP BY T.start_year
ORDER BY T.start_year DESC;
--
-- Query 21
-- What were the episodes of Fawlty Towers?
SELECT E.season_number, E.episode_number, T2.primary_title
FROM Titles AS T1, Titles AS T2, Episode_belongs_to AS E
WHERE T1.primary_title = 'Fawlty Towers'
AND T1.title_type = 'tvSeries'
AND T1.title_id = E.parent_tv_show_title_id
AND T2.title_type = 'tvEpisode'
AND T2.title_id = E.episode_title_id
ORDER BY E.season_number, E.episode_number;
--
-- Query 22
-- What were the names and average ratings of each episode of The X-Files?
SELECT E.season_number, E.episode_number, T2.primary_title, R.average_rating
FROM Titles AS T1, Titles AS T2, Episode_belongs_to AS E, Title_ratings AS R
WHERE T1.primary_title = 'The X-Files'
AND T1.title_type = 'tvSeries'
AND T1.title_id = E.parent_tv_show_title_id
AND T2.title_type = 'tvEpisode'
AND T2.title_id = E.episode_title_id
AND T2.title_id = R.title_id
ORDER BY E.season_number, E.episode_number;
--
