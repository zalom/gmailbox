class RegistrationsController < Devise::RegistrationsController
  before_action :set_user, only: [:update, :edit]
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_path, notice: 'Profile successfully updated!' }
      else
        format.html { render :edit, notice: 'Something went wrong!' }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(resource_name).permit(:email, :password, :password_confirmation,
                                         profile_attributes: [:user_id, :username, :first_name, :last_name, :phone, :occupation])
  end
end
