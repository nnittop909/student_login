class StudentLoginsController < ApplicationController

  def index
    if params[:id_number].present?
      @student = Student.friendly.find_by(id_number: params[:id_number])
      if @student.blank?
        redirect_to student_logins_path, notice: 'Wrong ID Number, try again!'
      elsif @student.logins.any?
        redirect_to student_logins_path, notice: 'You are already logged in.'
      elsif @student.present?
        @login = @student.logins.create!(:student_id => @student)
        if @login.save
          redirect_to student_logins_path, notice: 'You are signed in.'
        else
          render :new
        end
      end
    end
  end

end
