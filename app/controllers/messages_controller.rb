class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: [:new, :create]
  before_action :set_message, except: [:index, :new, :create]

  def new
    @message = current_user.sent_messages.new
  end

  def index
    @messages = current_user.received_messages.include_replies.or(current_user.sent_messages.include_replies).distinct
    @messages = current_user.sent_messages.only_threads.join_flags.exclude_drafts if params[:sent]
    @messages = current_user.messages.starred if params[:starred]
    @messages = current_user.sent_messages.drafts if params[:drafts]
    @messages = current_user.messages.trash if params[:trash]
  end

  def show
    @message.mark_read(current_user.id, @message.id) unless @message.read?(current_user.id)
    @replies = @message.replies.ordered if @message.replies.any?
  end

  def create
    @message = current_user.sent_messages.new(message_params)
    @message.recipient_id = @recipient
    respond_to do |format|
      if @message.save
        format.html { redirect_to current_user.received_messages }
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
          redirect_to current_user.received_messages, flash[:success] = 'You have successfully deleted a message!'
        end
      end
    end
  end

  private

  def set_recipient
    @recipient = User.find(params[:recipient_id])
  end

  def set_message
    if params[:sent]
      @message = current_user.sent_messages.only_threads.find(params[:id])
    elsif params[:drafts]
      @message = current_user.sent_messages.drafts.find(params[:id])
    elsif params[:trash]
      @message = current_user.messages.trash.find(params[:id])
    elsif params[:starred]
      @message = current_user.messages.starred.find(params[:id])
    else
      @message = current_user.received_messages.include_replies.or(current_user.sent_messages.include_replies).distinct.find(params[:id])
    end
  end

  def message_params
    params.require(:message).permit(:subject, :content, :user_id,
                                    :recipient_id, :sender_id,
                                    :is_read, :is_starred)
  end
end
