module MessagesHelper
  def inbox_sent_format(sent_at)
    case sent_at
    when sent_at.year < Time.now.year
      sent_at.strftime('%d/%m/%y')
    when sent_at.month <= Time.now.month && sent_at.day < Time.now.day
      sent_at.strftime('%B %d')
    else
      sent_at.strftime('%H:%M')
    end
  end

  def read_class(is_read)
    is_read ? '' : 'unread'
  end
end
