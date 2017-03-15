class Course < ApplicationRecord

	has_many :students

	def to_s
		name
	end
end
