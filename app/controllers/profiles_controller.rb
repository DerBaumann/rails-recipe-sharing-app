class ProfilesController < ApplicationController
  def show
    @user = Current.user
    @my_recipes_count = @user.recipes.count
    @published_count = @user.recipes.published.count
    @favourites_count = @user.favourites.count
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profil erfolgreich aktualisiert."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private
    def profile_params
      params.expect(user: [ :email_address, :password, :password_confirmation ])
    end
end
