class RemoveNameAndAddUsernameFirstNameAndLastNameToStaff < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :first_name, :string
    add_column :staffs, :last_name, :string
    add_column :staffs, :username, :string
    remove_column :staffs, :name, :string
  end
end
