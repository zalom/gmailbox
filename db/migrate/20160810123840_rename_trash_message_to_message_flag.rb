class RenameTrashMessageToMessageFlag < ActiveRecord::Migration[5.0]
  def self.up
    rename_table :trash_messages, :message_flags
    add_column :message_flags, :is_read, :boolean, default: false
    add_column :message_flags, :is_important, :boolean, default: false
    add_column :message_flags, :is_draft, :boolean, default: true
    add_column :message_flags, :is_trash, :boolean, default: false
    remove_column :messages, :is_read
    remove_column :messages, :is_important
    remove_column :messages, :is_draft
  end

  def self.down
    rename_table :message_flags, :trash_messages
    remove_column :trash_messages, :is_read
    remove_column :trash_messages, :is_important
    remove_column :trash_messages, :is_draft
    remove_column :trash_messages, :is_trash
    add_column :messages, :is_read, :boolean, default: false
    add_column :messages, :is_important, :boolean, default: false
    add_column :messages, :is_draft, :boolean, default: true
  end
end
