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
    message = MessageCreate.new(current_user, message_params, other_params)
    respond_to do |format|
      if message.create
        format.html { redirect_to root_path, notice: message.notice }
      else
        format.html { render :new, notice: 'Something went wrong!' }
      end
    end
  end

  def edit
  end

  def update
    message = MessageUpdate.new(@message, message_params)
    respond_to do |format|
      if message.update
        format.html { redirect_to root_path, notice: message.notice }
      else
        format.html { render :edit, notice: 'Something went wrong!' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @message.destroy
        format.html { redirect_to root_path, notice: 'Draft discarded!' }
      else
        format.html { render :edit, notice: 'Something went wrong!' }
      end
    end
  end

  private

  def set_message
    if params[:sent]
      @message = current_user.sent_messages.only_threads.find(params[:id])
    elsif params[:drafts] || params[:action] == 'update' || params[:action] == 'destroy'
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
    params.require(:message).permit(:subject, :content, :recipient_email, :thread_id, :draft)
  end

  def other_params
    params.permit(:id, :user_id, :draft, :reply)
  end
end
