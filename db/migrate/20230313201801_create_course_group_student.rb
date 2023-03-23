class CreateCourseGroupStudent < ActiveRecord::Migration[6.1]
  def change
    create_table :course_group_students, id: false do |t|
      t.belongs_to :course_group
      t.belongs_to :student
    end
  end
end
