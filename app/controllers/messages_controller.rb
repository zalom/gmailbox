class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: [:new, :create]
  before_action :set_message, except: [:index, :new, :create]

  def new
    @message = current_user.sent_messages.new
  end

  def index
    @messages = current_user.received_messages.thread.exclude_trash(current_user)
    @messages = current_user.sent_messages.thread.non_drafts(current_user) if params[:sent]
    @messages = current_user.messages.thread.important(current_user) if params[:important]
    @messages = current_user.sent_messages.thread.drafts(current_user) if params[:drafts]
    @messages = current_user.messages.thread.trash(current_user) if params[:trash]
  end

  def show
    @message.message_flags.mark_all_read
    if @message.replies.any?
      @replies = @message.replies.ordered
      @replies.each do |reply|
        reply.message_flags.mark_all_read
      end
    end
  end

  def create
    @message = current_user.sent_messages.new(message_params)
    @message.recipient_id = @recipient
    respond_to do |format|
      if @message.save
        format.html { redirect_to current_user.messages }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    respond_to do |format|
      if @message.destroy
        format.html do
          redirect_to current_user.messages, flash[:success] = 'You have successfully deleted a message!'
        end
      end
    end
  end

  private

  def set_recipient
    @recipient = User.find(params[:recipient_id])
  end

  def set_message
    @message = current_user.received_messages.find(params[:id])
    @message = current_user.sent_messages.thread.non_drafts(current_user).find(params[:id]) if params[:sent]
    @message = current_user.sent_messages.thread.drafts(current_user).find(params[:id]) if params[:drafts]
    @message = current_user.messages.thread.trash(current_user).find(params[:id]) if params[:trash]
    @message = current_user.messages.thread.important(current_user).find(params[:id]) if params[:important]
  end

  def message_params
    params.require(:message).permit(:subject, :content, :user_id,
                                    :recipient_id, :sender_id,
                                    :is_read, :is_important)
  end
end
