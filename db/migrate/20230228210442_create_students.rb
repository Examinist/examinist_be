class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :must_change_password, default: true
      t.string :academic_id

      t.timestamps
    end
  end
end
