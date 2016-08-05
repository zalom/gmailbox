class AddIsTrashToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :is_trash, :boolean, default: false
  end
end
