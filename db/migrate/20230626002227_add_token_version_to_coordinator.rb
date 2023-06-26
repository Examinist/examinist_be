class AddTokenVersionToCoordinator < ActiveRecord::Migration[6.1]
  def change
    add_column :coordinators, :token_version, :bigint, default: 0
  end
end
