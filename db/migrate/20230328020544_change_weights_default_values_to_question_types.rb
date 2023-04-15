class ChangeWeightsDefaultValuesToQuestionTypes < ActiveRecord::Migration[6.1]
  def change
    change_column_default :question_types, :easy_weight, from: 0, to: 1
    change_column_default :question_types, :medium_weight, from: 0, to: 2
    change_column_default :question_types, :hard_weight, from: 0, to: 3
  end
end
