class ChangeUniversityInFaculty < ActiveRecord::Migration[6.1]
  def change
    remove_column :faculties, :university_name
    add_reference :faculties, :university, null: false, foreign_key: true
  end
end
