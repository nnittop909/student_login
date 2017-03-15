class Student < ApplicationRecord

	include PgSearch

	has_many :logins
	has_many :internet_usages
	belongs_to :course
	belongs_to :year_level

  pg_search_scope( :search_by_name, 
                    against: [:first_name, :last_name, :middle_name, :full_name, :id_number],
                    :associated_against => {:course => [:name]},
                    using: { tsearch: { prefix: true }} )

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
  validates :first_name, :last_name, :middle_name, :id_number, :course_id, :year_level_id, :address, :gender, presence: true
  before_commit :set_full_name, :set_usage_status

  def self.created_between(hash={})
    if hash[:from_date] && hash[:to_date] && hash[:course_id]
    	course_id = hash[:course_id] unless hash[:course_id].blank?
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('course_id' => course_id).map { |s| s.internet_usages.where('created_at' => from_date..to_date) }
    elsif hash[:from_date] && hash[:to_date] && hash[:year_level_id]
    	year_level_id = hash[:year_level_id] unless hash[:year_level_id].blank?
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('year_level_id' => year_level_id).map { |s| s.internet_usages.where('created_at' => from_date..to_date) }
    elsif hash[:from_date] && hash[:to_date] && hash[:course_id] && hash[:year_level_id]
    	course_id = hash[:course_id] unless hash[:course_id].blank?
    	year_level_id = hash[:year_level_id] unless hash[:year_level_id].blank?
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.where('course_id' => course_id).where('year_level_id' => year_level_id).map { |s| s.internet_usages.where('created_at' => from_date..to_date) }
    elsif hash[:from_date] && hash[:to_date]
      from_date = hash[:from_date].kind_of?(Time) ? hash[:from_date] : Time.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00')).beginning_of_day
      to_date = hash[:to_date].kind_of?(Time) ? hash[:to_date] : Time.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59')).end_of_day
      all.map { |s| s.internet_usages.where('created_at' => from_date..to_date) }
    else
    	all
    end
  end

  def to_s
  	full_name
  end

  def fullname_and_id_number
    "#{id_number} - #{full_name}"
  end

	def fullname
		"#{last_name}, #{first_name} #{middle_name.first.capitalize}." 
	end

	def exceeded?
		if self.internet_usages.present?
			self.internet_usages.remaining.negative?
		else
			false
		end
	end

	def set_usage_status
		if exceeded?
			self.with_excess!
		else
			self.no_excess!
		end
	end

	def usage_alert
		if exceeded?
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
