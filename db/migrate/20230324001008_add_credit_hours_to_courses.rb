class AddCreditHoursToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :credit_hours, :integer
  end
end
