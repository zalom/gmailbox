class CreateTrashMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :trash_messages do |t|
      t.references :message, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
