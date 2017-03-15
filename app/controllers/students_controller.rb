class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy, :profile, :usages]
  skip_before_action :authenticate_user!
  before_action :check_auth
  autocomplete :student, :full_name, full: true

  def check_auth
    unless user_signed_in?
        redirect_to :controller => :student_logins
    end
  end

  def index
    if params[:full_name].present?
      @students = Student.search_by_name(params[:full_name]).page(params[:page]).per(30)
    else
      @students = Student.all.order(:last_name).page(params[:page]).per(30)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = StudentUsagesPdf.new(@students, view_context)
                send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Student Usages Report.pdf"
        end
      end
    end
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

  def scope_to_date
    @course_id = params[:course_id] if params[:course_id].present?
    @year_level_id = params[:year_level_id] if params[:year_level_id].present?
    @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Time.zone.now.beginning_of_day
    @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now.end_of_day
    @internet_usages = InternetUsage.created_between({from_date: @from_date, to_date: @to_date}).order(:created_at).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InternetUsagesPdf.new(@internet_usages, @course_id, @year_level_id, @from_date, @to_date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Usage Report.pdf"
      end
    end
  end

  private
    def set_student
      @student = Student.friendly.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:profile_photo, :first_name, :last_name, :middle_name, :gender, :id_number, :address, :course_id, :year_level_id)
    end
end
