class CreateBusyLabs < ActiveRecord::Migration[6.1]
  def change
    create_table :busy_labs do |t|
      t.references :lab, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
