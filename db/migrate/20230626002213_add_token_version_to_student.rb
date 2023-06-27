class AddTokenVersionToStudent < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :token_version, :bigint, default: 0
  end
end
