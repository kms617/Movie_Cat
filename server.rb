########################################################################################
# Movie-Catalog Challenge
#
# Build a movie catalog backed by the movies database.
# The catalog should support the following routes:

# Visiting /actors will show a list of actors, sorted alphabetically by name.
# Each actor name is a link to the details page for that actor.

# Visiting /actors/:id will show the details for a given actor.
# This page should contain a list of movies that the actor has starred in
# and what their role was. Each movie should link to the details page for that movie.

# Visiting /movies will show a table of movies, sorted alphabetically by title.
# The table includes the movie title, the year it was released, the rating, the genre,
# and the studio that produced it.
# Each movie title is a link to the details page for that movie.

# Visiting /movies/:id will show the details for the movie.
# This page should contain information about the movie (including genre and studio)
# as well as a list of all of the actors and their roles.
# Each actor name is a link to the details page for that actor.
#
########################################################################################

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

#####################################
#  Methods
#####################################

def db_connection
  begin
    connection = PG.connect(dbname: 'movies')

    yield(connection)

  ensure
    connection.close
  end
end


def get_all_actors
  query= %Q{SELECT * FROM actors ORDER BY name;}

  results = db_connection do |conn|
    conn.exec('SELECT * FROM actors ORDER BY name;')
  end

  results.to_a
end

def get_actor_info(actor_id)
  query =%Q{SELECT * FROM actor_characters
            WHERE id = $1;
            }

    results = db_connection do |conn|
      conn.exec(query, [actor_id])
    end

  results.to_a
end

def get_all_movies
  query = %Q{SELECT * FROM movie_info ORDER BY title;}

  results = db_connection do |conn|
    conn.exec(query)
  end

  results.to_a
end

def get_movie_info(movie_id)
  query =%Q{SELECT * FROM movie_info
            WHERE id = $1;
            }

    results = db_connection do |conn|
      conn.exec(query, [movie_id])
    end

  results.to_a
end

def get_movie_cast(movie_id)
  query =%Q{SELECT * FROM actor_characters
            WHERE movie_id = $1;
            }

    results = db_connection do |conn|
      conn.exec(query, [movie_id])
    end

  results.to_a
end

#######################################
#######################################
#  Routes
#######################################
get '/index' do
  erb :'index'
end


get '/actors' do

  @actors = get_all_actors

  erb :'actors/index'
end


get '/actors/:id' do

   @characters = get_actor_info(params[:id])
   @actor = {name: @characters[0]['name'], id: @characters[0][:id]
   }

   erb :'actors/show'
 end

 get '/movies' do

  @movies = get_all_movies

  erb :'movies/index'
 end


get '/movies/:id' do

  @movie = get_movie_info(params[:id])
  @cast = get_movie_cast(params[:id])

   erb :'movies/show'
 end

