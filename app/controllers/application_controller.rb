class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # remove line below in production
  # skip_before_action :verify_authenticity_token

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end
end
