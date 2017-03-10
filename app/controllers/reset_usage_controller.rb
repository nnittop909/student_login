class ResetUsageController < ApplicationController

	def reset
		InternetUsages.destroy_all
		redirect_to users_admin_index, notice: "Internet Usage has been cleared!"
	end
end