class RecipesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :resume_session, only: %i[ index show ]

  before_action :set_recipe, only: %i[ show edit update destroy ]
  before_action :authorize_owner!, only: %i[ edit update destroy ]

  # GET /recipes or /recipes.json
  def index
    @recipes = policy_scope(Recipe).search_by_title(params[:query])
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    authorize @recipe
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @recipe.ingredients.build

    authorize @recipe
  end

  # GET /recipes/1/edit
  def edit
    authorize @recipe

    @recipe.ingredients.build if @recipe.ingredients.empty?
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Current.user.recipes.build(recipe_params)

    authorize @recipe

    # Explicit Transaction
    saved = ActiveRecord::Base.transaction do
      @recipe.save || raise(ActiveRecord::Rollback)
    end

    respond_to do |format|
      if saved
        format.html { redirect_to @recipe, notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @recipe.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    authorize @recipe

    # Explicit Transaction
    updated = ActiveRecord::Base.transaction do
      @recipe.update(recipe_params) || raise(ActiveRecord::Rollback)
    end

    respond_to do |format|
      if updated
        format.html { redirect_to @recipe, notice: "Recipe was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @recipe.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    authorize @recipe

    @recipe.destroy!

    respond_to do |format|
      format.html { redirect_to recipes_path, notice: "Recipe was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def authorize_owner!
      unless @recipe.owned_by?(Current.user)
        redirect_to recipes_path, status: :forbidden, alert: "You can only edit or delete your own recipes."
      end
    end

    def set_recipe
      @recipe = Recipe.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(
        :title,
        :prep_time_minutes,
        :instructions,
        :is_published,
        ingredients_attributes: [
          :id,
          :name,
          :amount,
          :unit,
          :_destroy
        ]
      )
    end
end
