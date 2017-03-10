class SettingsController < ApplicationController

	def index
		@alloted_times = AllotedTime.all
	end
end