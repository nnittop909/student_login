class Login < ApplicationRecord
	belongs_to :student

	before_destroy :set_time_consumption

	def log_out_time
		Time.zone.now
	end

	def calculate_time_consumption
		log_out_time.to_time - self.created_at.to_time
	end

	def set_time_consumption
		InternetUsage.create!(:student_id => self.student.id, :time_in => self.created_at, :time_out => self.log_out_time, :time_consumption => self.calculate_time_consumption)
	end

end
