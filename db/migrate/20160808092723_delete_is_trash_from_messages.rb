class DeleteIsTrashFromMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :is_trash
  end
end
