class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_recipient, only: [:new, :create]

  def new
  end

  def index
    @messages = current_user.messages
  end

  def show
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_recipient
    @recipient = User.find(params[:user_id])
  end

  def message_params
    params.require(:message).permit(:subject, :content,
                                    :recipient_id, :sender_id,
                                    :is_read, :is_important)
  end
end
