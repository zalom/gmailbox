class MessageCreate
  def initialize(user, message_params)
    @message = user.sent_messages.new(message_params)
    @message_params = message_params
  end
  attr_reader :message, :message_params, :notice

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def create
    if recipient_exists?
      create_and_send_email
      @notice = 'Message successfully sent!'
    else
      create_as_draft
      @notice = 'Invalid email or no recipient found! Message saved as draft.'
    end
  end

  def create_as_draft
    return create_draft if message.save
  end

  def create_and_send_email
    message.class.transaction do
      set_recipient
      set_sent
      create_flags_for_sender
      create_flags_for_receiver
    end if message.save
  end

  protected

  def set_sent
    message.update(sent_at: Time.now) if message.sent_at.nil?
  end

  def set_subject_if_empty
    message.subject = 'no subject' if message.subject.blank?
  end

  def set_recipient
    message.recipient_id = User.find_by_email(message_params[:recipient_email]).id
  end

  def recipient_exists?
    email_valid? && matches_email_in_database?
  end

  def email_valid?
    message_params[:recipient_email].present? && !(message_params[:recipient_email] =~ VALID_EMAIL_REGEX).nil?
  end

  def matches_email_in_database?
    User.exists?(email: message_params[:recipient_email])
  end

  def create_flags_for_receiver
    message.message_flags.where(user_id: message.recipient_id).first_or_create(is_read: false, is_draft: false) unless message.recipient_id.nil?
  end

  def create_flags_for_sender
    message.message_flags.where(user_id: message.sender_id).first_or_create(is_read: true, is_draft: false) unless message.sender_id.nil?
  end

  def create_draft
    message.message_flags.where(user_id: message.sender_id).first_or_create(is_draft: true) unless message.sender_id.nil?
  end
end
