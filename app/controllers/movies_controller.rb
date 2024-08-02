class MoviesController < ApplicationController
  def index
    @list_of_movies = Movie.order(created_at: :desc)

    render(template: "movie_templates/index")
  end

  def show
    @the_movie = Movie.find_by(id: params.fetch("path_id"))

    if @the_movie.nil?
      redirect_to("/movies", alert: "Movie not found.")
    else
      render(template: "movie_templates/show")
    end
  end

  def create
    @the_movie = Movie.new(movie_params)

    if @the_movie.save
      redirect_to("/movies", notice: "Movie created successfully.")
    else
      redirect_to("/movies", alert: "Movie failed to create successfully.")
    end
  end

  def update
    @the_movie = Movie.find_by(id: params.fetch("path_id"))

    if @the_movie.nil?
      redirect_to("/movies", alert: "Movie not found.")
      return
    end

    if @the_movie.update(movie_params)
      redirect_to("/movies/#{@the_movie.id}", notice: "Movie updated successfully.")
    else
      redirect_to("/movies/#{@the_movie.id}", alert: "Movie failed to update successfully.")
    end
  end

  def destroy
    @the_movie = Movie.find_by(id: params.fetch("path_id"))

    if @the_movie.nil?
      redirect_to("/movies", alert: "Movie not found.")
      return
    end

    @the_movie.destroy

    redirect_to("/movies", notice: "Movie deleted successfully.")
  end

  private

  def movie_params
    params.permit(:query_title, :query_year, :query_duration, :query_description, :query_image, :query_director_id)
          .transform_keys { |key| key.gsub('query_', '') }
          .merge(year: params.fetch("query_year").to_i, duration: params.fetch("query_duration").to_i, director_id: params.fetch("query_director_id").to_i)
  end
end
