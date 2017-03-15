class Login < ApplicationRecord
	belongs_to :student

	before_destroy :create_time_consumption, :set_status

	def log_out_time
		Time.zone.now
	end

	def calculate_time_consumption
		log_out_time.to_time - self.created_at.to_time
	end

	def create_time_consumption
		InternetUsage.create!(:student_id => self.student.id, :course_id => self.student.course_id, :year_level_id => self.student.year_level_id, :time_in => self.created_at, :time_out => self.log_out_time, :time_consumption => self.calculate_time_consumption)
	end

	def exceeded?
		if self.student.internet_usages.present?
			self.student.internet_usages.remaining.negative?
		else
			self.student.internet_usages.remaining.positive?
		end
	end

	def set_usage_status
		if self.student.exceeded?
			self.student.with_excess!
		else
			self.student.no_excess!
		end
	end

	def set_status
		self.student.set_usage_status
	end

end
