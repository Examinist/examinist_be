class AddReferenceToCorrectAnswer < ActiveRecord::Migration[6.1]
  def change
    add_reference :correct_answers, :choice, foreign_key: true
  end
end
