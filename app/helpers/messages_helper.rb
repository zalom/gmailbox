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
      current_user.sent_messages.drafts(current_user.id).count
    when 'trash'
      current_user.messages.trash.count
    end
  end

  def actual_link_param
    params[:drafts] || params[:sent] ? 'recipient_email' : 'sender_email'
  end

  def link_for(message, msg_param)
    if params[:sent]
      link_to(message.send(msg_param.to_s.to_sym), message_path(message.id, sent: true), class: 'cell-link')
    elsif params[:drafts]
      link_to(message.send(msg_param.to_s.to_sym), edit_message_path(message.id, drafts: true), class: 'cell-link')
    elsif params[:trash]
      link_to(message.send(msg_param.to_s.to_sym), message_path(message.id, trash: true), class: 'cell-link')
    elsif params[:starred]
      link_to(message.send(msg_param.to_s.to_sym), message_path(message.id, starred: true), class: 'cell-link')
    else
      link_to(message.send(msg_param.to_s.to_sym), message_path(message.id), class: 'cell-link')
    end
  end

  def message_folder_link
    folders = %w(drafts starred trash sent)
    folder = params.permit!.to_h.first[0].to_s
    if folders.include?(folder)
      link_to(folder.capitalize, messages_path(folder.to_sym => true), data: { type: folder, title: folder.capitalize })
    else
      link_to('Inbox', root_path, data: { type: 'inbox', title: 'Inbox' })
    end
  end

  def params_exist?
    true if params[:starred] || params[:sent] || params[:trash] || params[:drafts]
  end

  def find_correct_recipient(thread)
    thread.sender_id == current_user.id ? thread.recipient_email : thread.sender_email
  end

  def folder_name
    folders = %w(drafts starred trash sent)
    folder = params.permit!.to_h.first[0].to_s
    folders.include?(folder) ? folder.capitalize : 'Inbox'
  end
end
