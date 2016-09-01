class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, except: [:index, :new, :create, :bulk_action]

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
    current_user.message_flags.mark_read(current_user, @message.id) unless @message.read?(current_user.id)
    @replies = @message.replies.ordered_replies if @message.replies.any?
  end

  def create
    message = MessageCreate.new(current_user, message_params, other_params)
    respond_to do |format|
      if message.create
        format.html { redirect_to root_path, notice: message.notice }
      else
        format.html { render :new, alert: 'Something went wrong!' }
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
        format.html { render :edit, alert: 'Something went wrong!' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @message.destroy
        format.html { redirect_to root_path, notice: 'Draft discarded!' }
      else
        format.html { render :edit, alert: 'Something went wrong!' }
      end
    end
  end

  def bulk_action
    respond_to do |format|
      begin
        MessageFlag.send(bulk_action_params.keys[0].to_sym, current_user, params[:thread_ids])
        format.js { render inline: 'location.reload();' }
      rescue TypeError => e
        format.html { redirect_to root_path, alert: "Params not good! Message: #{e}" }
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
    params.require(:message).permit(:subject, :content, :recipient_email, :thread_id, :thread_ids, :draft)
  end

  def other_params
    params.permit(:id, :user_id, :draft, :reply)
  end

  def bulk_action_params
    params.permit(:mark_read, :mark_unread, :mark_as_trash, :remove_from_trash, :mark_starred, :mark_unstarred)
  end
end
