module ApplicationHelper
  def derive_username(email)
    email[0, email.index('@')]
  end

  def user_full_name
    !current_user.profile.blank? && !current_user.profile.new_record? ? current_user.profile.full_name : current_user.email
  end

  def user_occupation
    current_user.profile.occupation unless current_user.profile.blank?
  end
end
