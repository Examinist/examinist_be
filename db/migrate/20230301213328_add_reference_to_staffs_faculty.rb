class AddReferenceToStaffsFaculty < ActiveRecord::Migration[6.1]
  def change
    add_reference :staffs, :faculty, null: false, foreign_key: true
  end
end
