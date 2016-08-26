class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, except: [:index, :new, :create]

  def new
    @message = current_user.sent_messages.new
  end

  def index
    @messages = current_user.messages.exclude_trash_and_drafts.ordered
    @messages = current_user.sent_messages.sent(current_user.id).ordered if params[:sent]
    @messages = current_user.messages.starred.ordered if params[:starred]
    @messages = current_user.sent_messages.drafts(current_user.id) if params[:drafts]
    @messages = current_user.messages.trash if params[:trash]
  end

  def show
    @message.mark_read(current_user.id) unless @message.read?(current_user.id)
    @replies = @message.replies.ordered_replies if @message.replies.any?
  end

  def create
    new_message = set_thread
    respond_to do |format|
      if new_message.create
        format.html { redirect_to root_path, notice: new_message.notice }
      else
        format.html { render :new, notice: 'Something went wrong!' }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @message.update(
        subject: message_params[:subject],
        content: message_params[:content],
        recipient_id: User.find_by_email(message_params[:recipient_email]).id,
        sent_at: Time.now
      )
        @message.sender.message_flags.where(message_id: @message.id).update(is_draft: false)
        @message.recipient.message_flags.where(message_id: @message.id).first_or_create(is_read: false) unless @message.recipient.nil?
        format.html { redirect_to root_path, notice: 'Message successfully sent!' }
      else
        format.html { render :edit, notice: 'Something went wrong!' }
      end
    end
  end

  def destroy
  end

  protected

  def set_thread
    if params.key?(params[:thread_id])
      MessageCreate.new(current_user, params, message_params, params[:id])
    else
      MessageCreate.new(current_user, params, message_params)
    end
  end

  def inspect_params
    50.times { print '#' }
    5.times { puts }
    puts params.inspect
    puts params[:id]
    5.times { puts }
    50.times { print '#' }
    debugger
  end

  private

  def set_message
    if params[:sent]
      @message = current_user.sent_messages.only_threads.find(params[:id])
    elsif params[:drafts] || params[:action] == 'update'
      @message = current_user.sent_messages.drafts(current_user.id).find(params[:id])
    elsif params[:trash]
      @message = current_user.messages.trash.find(params[:id])
    elsif params[:starred]
      @message = current_user.messages.starred.find(params[:id])
    else
      @message = current_user.messages.exclude_trash_and_drafts.find(params[:id])
    end
  end

  def message_params
    params.require(:message).permit(:id, :subject, :content, :recipient_email, :thread_id, :draft)
  end
end
