class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :must_change_password, default: true
      t.integer :role

      t.timestamps
    end
  end
end
