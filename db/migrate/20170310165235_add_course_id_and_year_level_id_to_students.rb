class AddCourseIdAndYearLevelIdToStudents < ActiveRecord::Migration[5.0]
  def change
  	add_column :students, :course_id, :integer
  	add_column :students, :year_level_id, :integer
  	add_index :students, :course_id
  	add_index :students, :year_level_id
  end
end
