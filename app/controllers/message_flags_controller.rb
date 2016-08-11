class TrashMessagesController < ApplicationController
  def create
    trash_message = TrashMessage.find_or_initialize_by(trash_message_params)
    respond_to do |format|
      if trash_message.save
        format.html { flash[:success] = 'Succesfully moved to trash!' }
      end
    end
  end

  def update
    trashed_message = TrashMessage.find(message_id: params[:message_id],
                                        user_id: params[:user_id])
    trashed_message.update_attributes(trash_message_params)
    trashed_message.save
  end

  private

  def trash_message_params
    params.require(:trash_message).permit(:user_id, :message_id)
  end
end
