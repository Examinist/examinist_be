class RenameCapcityToCapacityInLabs < ActiveRecord::Migration[6.1]
  def change
    rename_column :labs, :capcity, :capacity
  end
end
