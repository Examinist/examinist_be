class CreateLabs < ActiveRecord::Migration[6.1]
  def change
    create_table :labs do |t|
      t.string :name
      t.integer :capcity
      t.references :university, null: false, foreign_key: true

      t.timestamps
    end
  end
end
