class AddStaffToBusyLab < ActiveRecord::Migration[6.1]
  def change
    add_reference :busy_labs, :staff, foreign_key: true
  end
end
