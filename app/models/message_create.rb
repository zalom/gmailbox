class MessageCreate
  def initialize(user, message_params)
    @message = user.sent_messages.new(message_params)
    @message_params = message_params
  end
  attr_reader :message, :message_params, :notice

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def create
    50.times { print '#' }
    5.times { puts }
    puts "#{recipient_exists?}"
    5.times { puts }
    50.times { print '#' }

    if recipient_exists?
      send_email
      @notice = 'Message successfully sent!'
    else
      save_draft
      @notice = 'Invalid email or No recipient found! Message saved as draft.'
    end
  end

  def save_draft
    return message.mark_as_draft if message.save
  end

  def send_email
    message.class.transaction do
      set_recipient
      set_sent
      message.remove_from_drafts
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
end
