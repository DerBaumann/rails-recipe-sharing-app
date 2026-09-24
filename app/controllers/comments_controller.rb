class CommentsController < ApplicationController
  before_action :set_recipe

  def create
    @comment = @recipe.comments.build(comment_params)
    @comment.author = Current.user

    respond_to do |format|
      if @comment.save
        @recipe.comments.reload
        format.html { redirect_to @recipe, notice: "Bewertung gespeichert." }
        format.turbo_stream
      else
        format.html { render "recipes/show", status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "new_comment_form",
            partial: "comments/form",
            locals: { recipe: @recipe, comment: @comment }
          )
        }
      end
    end
  end

  def destroy
    @comment = Current.user.comments.find(params[:id])
    @comment.destroy
    @recipe.comments.reload

    respond_to do |format|
      format.html { redirect_to @recipe, notice: "Bewertung gelöscht." }
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.remove(helpers.dom_id(@comment)),
          turbo_stream.replace("comment_form_section", partial: "comments/form_section", locals: { recipe: @recipe }),
          turbo_stream.replace(helpers.dom_id(@recipe, :comments_header), partial: "comments/header", locals: { recipe: @recipe })
        ]
      }
    end
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end

    def comment_params
      params.expect(comment: [ :title, :body, :rating ])
    end
end
