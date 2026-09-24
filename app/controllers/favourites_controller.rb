class FavouritesController < ApplicationController
  before_action :set_recipe, only: [ :create, :destroy ]

  def index
    @recipes = Current.user.favourite_recipes
  end

  def create
    Current.user.favourites.find_or_create_by(recipe: @recipe)

    redirect_back_or_to @recipe
  end

  def destroy
    Current.user.favourites.find_by(recipe: @recipe)&.destroy

    redirect_back_or_to @recipe
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end
end
