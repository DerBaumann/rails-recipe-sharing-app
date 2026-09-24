class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # For pundit because it apparently expects this method
  def current_user
    Current.user
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    respond_to do |format|
      format.html { redirect_to root_path, alert: "Du hast keine Berechtigung für diese Aktion.", status: :forbidden }
      format.json { render json: { error: "Forbidden" }, status: :forbidden }
    end
  end
end
