class CreateQuestionTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :question_types do |t|
      t.string :name
      t.integer :easy_weight, default: 0
      t.integer :medium_weight, default: 0
      t.integer :hard_weight, default: 0
      t.float :ratio, default: 0
      t.references :course, null: false, foreign_key: true


      t.timestamps
    end
  end
end
