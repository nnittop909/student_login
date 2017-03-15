class StudentLoginsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  skip_before_action :authenticate_user!
  
  def index
    if params[:id_number].present?
      @student = Student.friendly.find_by(id_number: params[:id_number])
      if @student.blank?
        redirect_to student_logins_path, notice: 'ID Number is incorrect or does not exist, please try again!'
      elsif @student.logins.any?
        if request.referer == student_logins_url
          redirect_to student_logins_path, notice: 'Student is already signed in.'
        else
          redirect_to landing_index_path, notice: 'You are already signed in.'
        end
      elsif @student.present?
        @login = @student.logins.create!(:student_id => @student)
        if @login.save
          if request.referer == student_logins_url
            redirect_to logins_path, notice: 'Signed in successful.'
          else
            redirect_to landing_index_path, notice: 'You are now signed in.'
          end
        else
          render :index
        end
      end
    end
  end

end
