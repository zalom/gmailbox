class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # remove line below in production
  # skip_before_action :verify_authenticity_token
  before_action :set_users

  def set_users
    @users = User.all
  end

  protected

  def authenticate_user!(options = {})
    if user_signed_in?
      super(options)
    else
      redirect_to new_user_session_path
    end
  end
end
