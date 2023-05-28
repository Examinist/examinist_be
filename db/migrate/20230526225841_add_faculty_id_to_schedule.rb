class AddFacultyIdToSchedule < ActiveRecord::Migration[6.1]
  def change
    add_reference :schedules, :faculty, null: false, foreign_key: true
  end
end
