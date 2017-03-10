class Student < ApplicationRecord
	has_many :logins
	has_many :internet_usages

	enum gender:[:male, :female]
	enum usage_status: [:with_excess, :no_excess]

	extend FriendlyId
  friendly_id :id_number, use: :slugged

  has_attached_file :profile_photo,
                    styles: { large: "120x120>",
                   medium: "70x70>",
                    thumb: "40x40>",
                    small: "30x30>",
                    x_small: "20x20>"},
                      default_url: ":style/profile_default.jpg",
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment :profile_photo, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  before_save :set_full_name
  before_commit :set_usage_status

	def self.courses
		%w(BSCpE BSCE BSIT BSBA BSHM BST BSAC BEE BSE)
	end

	def self.year_levels
		%w(I II III IV V)
	end

	def course_and_year
		"#{course} - #{year_level}" 
	end

	def fullname
		"#{last_name}, #{first_name} #{middle_name.first.capitalize}." 
	end

	def with_excess?
		if self.internet_usages.present?
			self.internet_usages.remaining.negative?
		else
			self.internet_usages.remaining.positive?
		end
	end

	def set_usage_status
		if self.with_excess?
			self.with_excess!
		else
			self.no_excess!
		end
	end

	def usage_alert
		if with_excess?
			"with excess"
		else
			"no excess"
		end
	end

  private
  def set_full_name
    self.full_name = fullname
  end

end
