class AddPendingLabsAssignmentToExam < ActiveRecord::Migration[6.1]
  def change
    add_column :exams, :pending_labs_assignment, :boolean, default: true
  end
end
