class InternetUsage < ApplicationRecord
	belongs_to :student

	def time_diff
		self.time_out - self.time_in
	end

	def usage_in_time_format
		Time.at(time_diff.round.abs).utc.strftime "%H:%M:%S"
	end

	def self.sum_of_time_consumptions
		all.sum(:time_consumption)
	end

	def self.total_time_consumption
		Time.at(sum_of_time_consumptions.round.abs).utc.strftime "%H:%M:%S"
	end

	def self.total_alloted_time
		15 * 3600
	end

	def self.alloted_less_consumed
		self.total_alloted_time - sum_of_time_consumptions
	end

	def self.total_remaining
		Time.at(self.alloted_less_consumed.round.abs).utc.strftime "%H:%M:%S"
	end

	def self.excess
		if self.alloted_less_consumed < 0
			self.total_remaining
		else
			Time.at(0).utc.strftime "%H:%M:%S"
		end
	end

	def time_to_int
		Time.now.to_i 
	end

	def int_to_time
		Time.at(time_to_int)
	end

end
