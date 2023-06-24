class ChangeStudentIdInStudentExam < ActiveRecord::Migration[6.1]
  def change
    change_column_null :student_exams, :student_id, true
  end
end
