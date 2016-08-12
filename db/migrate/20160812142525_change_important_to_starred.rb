class ChangeImportantToStarred < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :message_flags, :is_important, :is_starred
  end

  def self.down
    rename_column :message_flags, :is_starred, :is_important
  end
end
