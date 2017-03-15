class SettingsController < ApplicationController

	def index
		@alloted_times = AllotedTime.all
		@courses = Course.all
	end
end