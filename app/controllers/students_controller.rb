class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy, :profile, :usages]
  skip_before_action :authenticate_user!
  before_action :check_auth

  def check_auth
    unless user_signed_in?
        redirect_to :controller => :student_logins
    end
  end

  def index
    @students = Student.all
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to profile_student_path(@student), notice: 'Student was successfully created.'
    else
      ender :new
    end
  end

  def update
    if @student.update(student_params)
      redirect_to profile_student_path(@student), notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: 'Student was successfully destroyed.'
  end

  def profile
  end

  def usages
  end

  private
    def set_student
      @student = Student.friendly.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :middle_name, :gender, :id_number, :address, :course, :year_level)
    end
end
