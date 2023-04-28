class AddIsAnswerToChoices < ActiveRecord::Migration[6.1]
  def change
    add_column :choices, :is_answer, :boolean, default: false
  end
end
