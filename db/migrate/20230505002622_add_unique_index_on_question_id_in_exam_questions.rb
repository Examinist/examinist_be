class AddUniqueIndexOnQuestionIdInExamQuestions < ActiveRecord::Migration[6.1]
  def change
    add_index :exam_questions, [:exam_id, :question_id], unique: true
  end
end
