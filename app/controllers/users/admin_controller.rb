class Users::AdminController < ApplicationController
  def index
  	@users = User.order('created_at desc').all
  	@students = Student.order("last_name").all
  end
end
