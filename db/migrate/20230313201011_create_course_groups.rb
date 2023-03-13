class CreateCourseGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :course_groups do |t|
      t.string :name
      t.references :course, null: false, foreign_key: true
      t.datetime :end_date

      t.timestamps
    end
  end
end
