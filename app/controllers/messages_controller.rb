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
  end

  def destroy
  end

  protected

  def set_thread
    if params.key?(params[:thread_id])
      inspect_params
      MessageCreate.new(current_user, message_params, params[:id])
    else
      inspect_params
      MessageCreate.new(current_user, message_params)
    end
  end

  def inspect_params
    50.times { print '#' }
    5.times { puts }
    puts params.inspect
    puts params[:id]
    puts message_params.inspect
    5.times { puts }
    50.times { print '#' }
    debugger
  end

  private

  def set_message
    if params[:sent]
      @message = current_user.sent_messages.only_threads.find(params[:id])
    elsif params[:drafts]
      @message = current_user.sent_messages.drafts(current_user.id).find(params[:id])
    elsif params[:trash]
      @message = current_user.messages.trash.find(params[:id])
    elsif params[:starred]
      @message = current_user.messages.starred.find(params[:id])
    else
      @message = current_user.messages.only_threads.exclude_trash_and_drafts.find(params[:id])
    end
  end

  def message_params
    params.require(:message).permit(:id, :subject, :content, :recipient_email, :thread_id, :draft)
  end
end
