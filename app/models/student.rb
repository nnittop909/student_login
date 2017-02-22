class Student < ApplicationRecord
	has_many :logins

	enum gender:[:male, :female]

	extend FriendlyId
  friendly_id :id_number, use: :slugged

	def self.courses
		%w(BSCpE BSCE BSIT BSBA BSHM BST BSAC BEE BSE)
	end

	def self.year_levels
		%w(I II III IV V)
	end

	def full_name
		"#{last_name}, #{first_name} #{middle_name.first.capitalize}." 
	end

end
