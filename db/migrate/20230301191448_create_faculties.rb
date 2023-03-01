class CreateFaculties < ActiveRecord::Migration[6.1]
  def change
    create_table :faculties do |t|
      t.string :faculty_name
      t.string :university_name

      t.timestamps
    end
  end
end
