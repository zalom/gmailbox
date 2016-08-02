class AddUserFieldsAndIsDraftFieldToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :recipient_id, :integer
    add_column :messages, :sender_id, :integer
    add_column :messages, :is_draft, :boolean, null: false, default: true
  end
end
