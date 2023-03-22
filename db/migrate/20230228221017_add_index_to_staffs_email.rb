class AddIndexToStaffsEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :staffs, :email, unique: true
  end
end
