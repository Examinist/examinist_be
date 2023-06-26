class CreateStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    create_table :student_answers do |t|
      t.references :student_exam, null: false, foreign_key: true
      t.references :exam_question, null: false, foreign_key: true
      t.string :answer
      t.float :score

      t.timestamps
    end
  end
end
