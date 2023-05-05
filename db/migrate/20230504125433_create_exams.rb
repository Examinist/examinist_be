class CreateExams < ActiveRecord::Migration[6.1]
  def change
    create_table :exams do |t|
      t.references :course, null: false, foreign_key: true
      t.references :staff, null: false, foreign_key: true
      t.string :title
      t.datetime :starts_at
      t.integer :duration
      t.integer :total_score
      t.integer :status
      t.boolean :is_auto, default: false
      t.boolean :has_models, default: false

      t.timestamps
    end
  end
end
