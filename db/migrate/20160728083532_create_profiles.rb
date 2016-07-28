class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :occupation

      t.timestamps
    end
  end
end
