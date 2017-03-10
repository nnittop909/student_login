class AddFullNameToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :full_name, :string
  end
end
