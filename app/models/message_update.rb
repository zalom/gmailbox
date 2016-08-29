class MessageUpdate
  def initialize(message, message_params)
    @message = message
    @message_params = message_params
  end
  attr_reader :message, :message_params, :notice

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def update
    if recipient_exists?
      send_email
      @notice = 'Message successfully sent!'
    else
      @notice = 'Recipient not found!'
    end
  end

  def send_email
    message.class.transaction do
      set_subject_if_empty
      set_recipient
      set_sent
      update_flags_for_sender
      create_flags_for_recipient
    end if message.update(message_params)
  end

  protected

  def set_subject_if_empty
    message.subject = 'no subject' if message.subject.blank?
  end

  def set_recipient
    message.update(recipient_id: User.find_by_email(message_params[:recipient_email]).id)
  end

  def set_sent
    message.update(sent_at: message.updated_at) if message.sent_at.nil?
  end

  def create_flags_for_recipient
    return if message.recipient_id.nil?
    message.message_flags.where(user_id: message.recipient).first_or_create(is_read: false, is_draft: false)
  end

  def update_flags_for_sender
    return if message.sender_id.nil?
    message.message_flags.where(user_id: message.sender_id).first_or_initialize.update(is_read: true, is_draft: false)
  end

  def recipient_exists?
    email_valid? && matches_email_in_database?
  end

  def email_valid?
    !message_params[:recipient_email].blank? && !(message_params[:recipient_email] =~ VALID_EMAIL_REGEX).nil?
  end

  def matches_email_in_database?
    User.exists?(email: message_params[:recipient_email])
  end
end
