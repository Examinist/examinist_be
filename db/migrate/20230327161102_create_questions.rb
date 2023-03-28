class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.references :question_type, foreign_key: true
      t.references :topic, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.text :header
      t.integer :difficulty
      t.integer :number_of_choices
      t.integer :answer_type

      t.timestamps
    end
  end
end
