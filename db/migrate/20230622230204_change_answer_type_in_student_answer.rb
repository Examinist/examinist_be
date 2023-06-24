class ChangeAnswerTypeInStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    remove_column :student_answers, :answer
    add_column :student_answers, :answer, :string, array: true, default: []
  end
end
