class MessageCreate
  def initialize(user, message_params)
    @message = user.sent_messages.new(message_params)
    @message_params = message_params
    @user = user
  end
  attr_reader :message, :message_params, :notice

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def create
    if email_valid? && user.matches_user_in_database
      send_email
      @notice = 'Message successfully sent!'
    else
      save_draft
      @notice = 'No recipient! Message saved as draft.'
    end
  end

  def save_draft
    return message.mark_as_draft if message.save
  end

  def send_email
    self.class.transaction do
      set_recipient
      set_sent
      message.remove_from_drafts
    end if message.save
  end

  protected

  def set_sent
    message.is_sent = Time.now if message.is_sent.nil?
  end

  def set_subject_if_empty
    message.subject = 'no subject' if message.subject.blank?
  end

  def set_recipient
    message.recipient_id = User.find_by_email(message_params[:recipient_email]).id
  end

  def email_valid?
    message_params[:recipient_emai].present? && !(message_params[:recipient_emai] =~ VALID_EMAIL_REGEX).nil?
  end
end
