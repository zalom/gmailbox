class MessageCreate
  def initialize(user, message_params, other_params = {})
    @message = user.sent_messages.new(message_params)
    @message_params = message_params
    @thread_id = message_params[:thread_id]
    @other_params = other_params
  end
  attr_reader :message, :message_params, :notice, :thread_id, :other_params
  attr_accessor :redirect_location

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def create
    if recipient_exists? && !save_as_draft?
      create_and_send_email
      @notice = 'Message successfully sent!'
    else
      create_as_draft
      @notice = recipient_exists? ? 'Message saved as draft.' : 'Recipient not known! ' + 'Message saved as draft.'
    end
  end

  def create_as_draft
    set_recipient
    if message.save
      message.class.transaction do
        create_draft
      end
    end
    self.redirect_location = 'drafts'
  end

  def create_and_send_email
    set_recipient
    if message.save
      message.class.transaction do
        set_sent
        set_thread
        create_flags_for_sender
        create_flags_for_recipient
        set_conversation_unread_for_recipient
      end
    end
    redirect_to_thread_or_inbox
  end

  def redirect_to_thread_or_inbox
    self.redirect_location = message.thread.blank? ? 'inbox' : message.thread
  end

  protected

  def create_draft
    return if message.sender.blank?
    message.message_flags.where(user_id: message.sender_id).first_or_create(is_read: true, is_draft: true)
  end

  def set_sent
    message.update(sent_at: Time.now) if message.sent_at.nil?
  end

  def set_subject_if_empty
    message.subject = 'no subject' if message.subject.blank?
  end

  def set_thread
    message.update(thread_id: thread_id) if message_params[:thread_id].nil?
  end

  def set_recipient
    return unless message_params[:recipient_email].blank? || !recipient_exists?
    message.update(recipient_id: User.find_by_email(message_params[:recipient_email]).id)
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

  def save_as_draft?
    message_params.key?(:draft) || other_params.key?(:draft)
  end

  def create_flags_for_recipient
    return if message.recipient_id.nil?
    message.message_flags.where(user_id: message.recipient_id).first_or_create(is_draft: false)
  end

  def create_flags_for_sender
    return if message.sender_id.nil?
    message.message_flags.where(user_id: message.sender_id).first_or_create(is_read: true, is_draft: false)
  end

  def set_conversation_unread_for_recipient
    return if message.thread.blank?
    message.thread.message_flags.where(user_id: message.recipient_id).update(is_read: false)
  end
end
