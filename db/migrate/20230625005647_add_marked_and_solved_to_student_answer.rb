class AddMarkedAndSolvedToStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :student_answers, :marked, :boolean, default: false
    add_column :student_answers, :solved, :boolean, default: false
  end
end
