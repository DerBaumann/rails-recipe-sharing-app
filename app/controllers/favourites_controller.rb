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

    # redirect_back_or_to @recipe

    respond_to do |format|
      format.html { redirect_back_or_to recipes_path }
      format.turbo_stream {
        render turbo_stream: [
          # Wird NUR auf der Favoriten-Seite ausgeführt (wo :favourite_card existiert):
          turbo_stream.remove(helpers.dom_id(@recipe, :favourite_card)),

          # Wird ÜBERALL ausgeführt (Detail- & Rezept-Übersicht):
          turbo_stream.replace(
            helpers.dom_id(@recipe, :favourite_button),
            partial: "favourites/toggle_button",
            locals: { recipe: @recipe }
          )
        ]
      }
    end
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end
end
