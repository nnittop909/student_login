class AddStudentIdTimeInAndTimeOutToInternetUsages < ActiveRecord::Migration[5.0]
  def change
  	add_column :internet_usages, :student_id, :integer
  	add_column :internet_usages, :time_in, :datetime
  	add_column :internet_usages, :time_out, :datetime
  	add_index :internet_usages, :student_id
  end
end
