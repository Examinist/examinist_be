class RemoveBusyLabFromStudentExam < ActiveRecord::Migration[6.1]
  def change
    remove_reference :student_exams, :busy_lab, foreign_key: true
  end
end
