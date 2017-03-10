class InternetUsage < ApplicationRecord
	belongs_to :students

	def time_diff
		self.time_out - self.time_in
	end

	def usage_in_time_format
		hours = (time_diff.round/3600).abs
		Time.at(time_diff.round).utc.strftime "#{hours}:%M:%S"
	end

	def self.sum_of_time_consumptions
		all.sum(:time_consumption)
	end

	def self.total_time_consumption
		hours = (sum_of_time_consumptions.round/3600).abs
		Time.at(sum_of_time_consumptions.round).utc.strftime "#{hours}:%M:%S"
	end

	def self.total_alloted_time
		if AllotedTime.any?
			AllotedTime.last.duration.to_i * 3600
		else
			15 * 3600
		end
	end

	def self.remaining
		self.total_alloted_time - sum_of_time_consumptions
	end

	def self.total_remaining
		if self.remaining.negative? || self.remaining.zero?
			Time.at(0).utc.strftime "%H:%M:%S"
		else
			Time.at(self.remaining.round.abs).utc.strftime "%H:%M:%S"
		end
	end

	def self.excess
		if remaining < 0
			hours = (remaining.to_f/3600).to_i.abs
			Time.at(remaining.round.abs).utc.strftime "#{hours}:%M:%S"
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
