class ApplicationController < ActionController::Base

  # include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :account_url

  def after_sign_in_path_for(current_user)
    users_admin_index_url
  end

  def account_url
    return new_user_session_url unless user_signed_in?
    if user_signed_in?
      edit_user_registration_url
    end
  end

  protected
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private
  def permission_denied
    redirect_to after_sign_in_path_for(current_user), alert: "We're sorry but you are not allowed to access this page or feature."
    return
  end
end
