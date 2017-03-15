class InternetUsage < ApplicationRecord
	belongs_to :student
	belongs_to :year_level
	belongs_to :course

	def self.filter_with(hash={})
    if hash[:from_date] && hash[:to_date] && hash[:course_id].present?
    	course_id = hash[:course_id] unless hash[:course_id].blank?
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('created_at' => from_date..to_date).where(:course_id => course_id)

    elsif hash[:from_date] && hash[:to_date] && hash[:year_level_id].present?
    	year_level_id = hash[:year_level_id] unless hash[:year_level_id].blank?
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('created_at' => from_date..to_date).where('year_level_id' => year_level_id)

    elsif hash[:from_date] && hash[:to_date] && hash[:course_id].present? && hash[:year_level_id].present?
    	course_id = hash[:course_id] unless hash[:course_id].blank?
    	year_level_id = hash[:year_level_id] unless hash[:year_level_id].blank?
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('created_at' => from_date..to_date).where('course_id' => course_id).where('year_level_id' => year_level_id)

    elsif hash[:from_date] && hash[:to_date] && hash[:student_id]
    	student_id = hash[:student_id] unless hash[:student_id].blank?
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('created_at' => from_date..to_date).where('student_id' => student_id)

    elsif hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('created_at' => from_date..to_date)
    else
    	all
    end
  end

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
