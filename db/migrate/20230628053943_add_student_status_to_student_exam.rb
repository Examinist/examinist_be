class AddStudentStatusToStudentExam < ActiveRecord::Migration[6.1]
  def change
    add_column :student_exams, :student_status, :integer
  end
end
