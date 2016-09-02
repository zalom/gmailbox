module ApplicationHelper
  def derive_username(email)
    email[0, email.index('@')]
  end

  def user_full_name
    if !(current_user.profile.blank?)
      #current_user.profile.first_name + ' ' + current_user.profile.last_name
      current_user.email

    else
      current_user.email
    end
  end

  def user_occupation
    current_user.profile.occupation unless current_user.profile.blank?
  end
end
