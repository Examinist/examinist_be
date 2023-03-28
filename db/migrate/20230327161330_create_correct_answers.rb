class CreateCorrectAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :correct_answers do |t|
      t.references :question, null: false, foreign_key: true
      t.text :answer

      t.timestamps
    end
  end
end
