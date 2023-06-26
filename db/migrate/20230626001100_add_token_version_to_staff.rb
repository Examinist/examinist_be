class AddTokenVersionToStaff < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :token_version, :bigint, default: 0
  end
end
