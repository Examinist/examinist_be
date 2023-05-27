class AddSceduleIdToExam < ActiveRecord::Migration[6.1]
  def change
    add_reference :exams, :schedule, foreign_key: true
  end
end
