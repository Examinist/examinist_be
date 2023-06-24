class AddBusyLabToStudentExam < ActiveRecord::Migration[6.1]
  def change
    add_reference :student_exams, :busy_lab, null: false, foreign_key: true
  end
end
