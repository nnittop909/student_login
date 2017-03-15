class ResetUsagesController < ApplicationController

	def reset
		@internet_usages = InternetUsage.all
		@internet_usages.destroy_all
		redirect_to students_path, notice: "Internet Usage has been cleared!"
	end
end