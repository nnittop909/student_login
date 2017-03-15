class AddCourseIdYearLevelIdToInternetUsages < ActiveRecord::Migration[5.0]
  def change
  	add_column :internet_usages, :course_id, :integer
  	add_column :internet_usages, :year_level_id, :integer
  	add_index :internet_usages, :course_id
  	add_index :internet_usages, :year_level_id
  end
end
