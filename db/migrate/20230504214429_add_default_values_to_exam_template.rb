class AddDefaultValuesToExamTemplate < ActiveRecord::Migration[6.1]
  def change
    change_column_default :exam_templates, :easy, from: nil, to: 60
    change_column_default :exam_templates, :medium, from: nil, to: 30
    change_column_default :exam_templates, :hard, from: nil, to: 10
  end
end
