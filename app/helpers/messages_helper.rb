module MessagesHelper
  def inbox_sent_format(sent_at)
    unless sent_at.nil?
      case sent_at
      when sent_at.year < Time.now.year
        sent_at.strftime('%d/%m/%y')
      when sent_at.month <= Time.now.month && sent_at.day < Time.now.day
        sent_at.strftime('%B %d')
      else
        sent_at.strftime('%H:%M')
      end
    end
  end

  def time_sent_on(message = @message)
    message.sent_at.strftime("%H:%M %d %b %Y") unless message.sent_at.nil?
  end

  def read_class(read)
    read ? '' : 'unread'
  end

  def starred_class(starred)
    starred ? 'fa-star' : 'fa-star-o'
  end

  def count_messages(type)
    case type
    when 'unread'
      current_user.messages.unread.count
    when 'drafts'
      current_user.sent_messages.drafts.count
    when 'trash'
      current_user.messages.trash.count
    end
  end

  def actual_link_param
    params[:drafts] || params[:sent] ? 'recipient_email' : 'sender_email'
  end

  def link_for(message, msg_param)
    if params[:sent]
      link_to(message.send("#{msg_param}".to_sym),
              message_path(message.id, sent: true), class: 'cell-link')
    elsif params[:drafts]
      link_to(message.send("#{msg_param}".to_sym),
              message_path(message.id, drafts: true), class: 'cell-link')
    elsif params[:trash]
      link_to(message.send("#{msg_param}".to_sym),
              message_path(message.id, trash: true), class: 'cell-link')
    else
      link_to(message.send("#{msg_param}".to_sym),
              message_path(message.id), class: 'cell-link')
    end
  end

  def derive_username(email)
    email[0, email.index('@')]
  end
end
