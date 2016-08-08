class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: [:new, :create]
  before_action :set_message, except: [:index, :new, :create]

  def new
    @message = current_user.messages.new
  end

  def index
    @messages = current_user.messages.exclude_trash
    @messages = current_user.sent_messages.non_drafts.exclude_trash if params[:sent]
    @messages = current_user.messages.important.exclude_trash if params[:important]
    @messages = current_user.sent_messages.drafts.exclude_trash if params[:drafts]
    @messages = Message.trash(current_user.id) if params[:trash]
  end

  def show
    @message.mark_read
  end

  def create
    @message = current_user.messages.new(message_params)
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
          redirect_to current_user.messages,
          flash[:success] = 'You have successfully deleted a message!'
        end
      end
    end
  end

  private

  def set_recipient
    @recipient = User.find(params[:user_id])
  end

  def set_message
    if params[:sent]
      @message = current_user.sent_messages.non_drafts.find(params[:id])
    elsif params[:drafts]
      @message = current_user.sent_messages.drafts.find(params[:id])
    elsif params[:trash]
      @message = Message.trash(current_user.id).trash_messages.find(params[:id])
    else
      @message = current_user.messages.find(params[:id])
    end
  end

  def message_params
    params.require(:message).permit(:subject, :content, :user_id,
                                    :recipient_id, :sender_id,
                                    :is_read, :is_important)
  end
end
