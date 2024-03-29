class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :content
      t.integer :thread_id
      t.datetime :sent_at
      t.boolean :is_read, null: false, default: true
      t.boolean :is_important, default: false

      t.timestamps
    end
  end
end
