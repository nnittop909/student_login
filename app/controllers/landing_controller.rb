class LandingController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  skip_before_action :authenticate_user!
  layout 'sign_in'

  def index
    
  end

end
