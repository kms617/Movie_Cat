CREATE VIEW movie_info AS
  SELECT movies.id, movies.title, movies.year,
          movies.rating, movies.genre_id, movies.studio_id, genres.name AS genre, studios.name AS studio
  FROM movies
  JOIN genres ON movies.genre_id = genres.id
  JOIN studios ON movies.studio_id = studios.id;
