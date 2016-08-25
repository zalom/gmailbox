class MessageCreate
  def initialize(user, message_params, thread_id = nil)
    @message = user.sent_messages.new(message_params)
    @message_params = message_params
    @thread_id = thread_id
  end
  attr_reader :message, :message_params, :notice, :thread_id

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def create
    if recipient_exists? && !message_params.key?(:draft)
      create_and_send_email
      @notice = 'Message successfully sent!'
    else
      create_as_draft
      notice_msg = 'Message saved as draft.'
      @notice = recipient_exists? ? notice_msg : 'Recipient not known! ' + notice_msg
    end
  end

  def create_as_draft
    inspect_params
    message.class.transaction do
      create_draft
    end if message.save
  end

  def create_and_send_email
    inspect_params
    message.class.transaction do
      set_recipient
      set_sent
      set_thread
      create_flags_for_sender
      create_flags_for_receiver
    end if message.save
  end

  protected

  def inspect_params
    50.times { print '#' }
    5.times { puts }
    puts message_params.inspect
    puts thread_id
    5.times { puts }
    50.times { print '#' }
    debugger
  end

  def create_draft
    return if message.sender_id.nil?
    message.message_flags.where(user_id: message.sender_id).first_or_create(is_read: true, is_draft: true)
  end

  def set_sent
    message.update(sent_at: Time.now) if message.sent_at.nil?
  end

  def set_subject_if_empty
    message.subject = 'no subject' if message.subject.blank?
  end

  def set_thread
    message.thread_id = thread_id unless message_params[:thread_id].nil?
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
    return if message.recipient_id.nil?
    message.message_flags.where(user_id: message.recipient_id).first_or_create(is_read: false, is_draft: false)
  end

  def create_flags_for_sender
    return if message.sender_id.nil?
    message.message_flags.where(user_id: message.sender_id).first_or_create(is_read: true, is_draft: false)
  end

  private

  def thread_check_fails?

  end
end
