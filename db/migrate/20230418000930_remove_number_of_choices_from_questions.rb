class RemoveNumberOfChoicesFromQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :questions, :number_of_choices
  end
end
