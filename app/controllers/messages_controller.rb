class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: [:new, :create]
  before_action :set_message, except: [:index, :new, :create]

  def new
    @message = current_user.messages.new
  end

  def index
    @messages = current_user.messages
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
        format.html { redirect_to current_user.messages, flash[:success] = 'You have successfully deleted a message!' }
      end
    end
  end

  private

  def set_recipient
    @recipient = User.find(params[:user_id])
  end

  def set_message
    @message = current_user.messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:subject, :content,
                                    :recipient_id, :sender_id,
                                    :is_read, :is_important)
  end
end
