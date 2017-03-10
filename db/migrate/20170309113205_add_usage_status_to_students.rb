class AddUsageStatusToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :usage_status, :integer
  end
end
