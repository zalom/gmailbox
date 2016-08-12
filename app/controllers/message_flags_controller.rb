class MessageFlgasController < ApplicationController
  def create
    message_flags = MessageFlag.find_or_initialize_by(message_flags_params)
    respond_to do |format|
      if message_flags.save
        format.html { flash[:success] = 'Succesfully moved to trash!' }
      end
    end
  end

  def update
    flagged_message = MessageFlag.find(message_id: params[:message_id],
                                        user_id: params[:user_id])
    flagged_message.update_attributes(message_flags_params)
    flagged_message.save
  end

  private

  def message_flags_params
    params.require(:message_flag).permit(:user_id, :message_id, :is_read,
                                         :is_trash, :is_important)
  end
end
