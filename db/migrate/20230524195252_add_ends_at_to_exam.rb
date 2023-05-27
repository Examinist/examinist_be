class AddEndsAtToExam < ActiveRecord::Migration[6.1]
  def change
    add_column :exams, :ends_at, :datetime
  end
end
