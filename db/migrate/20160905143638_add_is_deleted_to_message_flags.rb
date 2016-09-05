class AddIsDeletedToMessageFlags < ActiveRecord::Migration[5.0]
  def change
    add_column :message_flags, :is_deleted, :boolean, default: false
  end
end
