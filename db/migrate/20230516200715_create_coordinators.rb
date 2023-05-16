class CreateCoordinators < ActiveRecord::Migration[6.1]
  def change
    create_table :coordinators do |t|
      t.string :username
      t.references :university, null: false, foreign_key: true
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
