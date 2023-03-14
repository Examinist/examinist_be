class CreateCourseGroupStaff < ActiveRecord::Migration[6.1]
  def change
    create_table :course_group_staffs, id: false do |t|
      t.belongs_to :course_group
      t.belongs_to :staff
    end
  end
end
