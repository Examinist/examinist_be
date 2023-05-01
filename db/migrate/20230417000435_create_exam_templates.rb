class CreateExamTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :exam_templates do |t|\
      t.float :easy
      t.float :medium
      t.float :hard
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
