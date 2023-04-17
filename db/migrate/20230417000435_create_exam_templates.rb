class CreateExamTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :exam_templates do |t|\
      t.string :name
      t.float :easy, default: 60.0
      t.float :medium, default: 30.0
      t.float :hard, default: 10.0
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
