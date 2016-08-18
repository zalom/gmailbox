class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, except: [:index, :new, :create]

  def new
    @message = current_user.sent_messages.new
  end

  def index
    @messages = current_user.received_messages.include_replies.or(current_user.sent_messages.include_replies).distinct
    @messages = current_user.sent_messages.only_threads.sent(current_user.id) if params[:sent]
    @messages = current_user.messages.starred if params[:starred]
    @messages = current_user.sent_messages.drafts(current_user.id) if params[:drafts]
    @messages = current_user.messages.trash if params[:trash]
  end

  def show
    @message.mark_read(current_user.id) unless @message.read?(current_user.id)
    @replies = @message.replies.ordered if @message.replies.any?
  end

  def create
    @message = current_user.sent_messages.new(message_params)
    respond_to do |format|
      if User.valid_email?(params[:recipient_email])
        @message.recipient_id = User.find_by_email(params[:recipient_email]).id
        if @message.save
          @message.set_sent
          @message.remove_from_drafts
          format.html { redirect_to root_path, notice: 'Message successfully sent!' }
        end
      else
        @message.recipient_id = nil
        if @message.save
          format.html { redirect_to root_path, data: { confirm: 'Save as draft?' }, notice: 'Message saved as draft.' }
          @message.mark_as_draft
        end
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
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
      @message = current_user.received_messages.include_replies.or(current_user.sent_messages.include_replies).distinct.find(params[:id])
    end
  end

  def message_params
    params.require(:message).permit(:subject, :content, :recipient_email)
  end
end
