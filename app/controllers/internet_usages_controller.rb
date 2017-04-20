class InternetUsagesController < ApplicationController

	def scope_to_date
		@course_id = params[:course_id] if params[:course_id].present?
    @year_level_id = params[:year_level_id] if params[:year_level_id].present?
    @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Time.zone.now.beginning_of_day if params[:from_date].present?
    @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now.end_of_day if params[:to_date].present?
    if params[:from_date].present? && params[:to_date].present?
      @internet_usages = InternetUsage.filter_with({from_date: @from_date, to_date: @to_date}).order(:created_at).page(params[:page]).per(30)
    else
      @internet_usages = InternetUsage.order(:created_at).page(params[:page]).per(30)
    end
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InternetUsagesPdf.new(@internet_usages, @course_id, @year_level_id, @from_date, @to_date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Usage Report.pdf"
      end
    end
  end

  def student_scope_to_date
    @student_id = params[:student_id] if params[:student_id].present?
    @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Time.zone.now.beginning_of_day if params[:from_date].present?
    @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now.end_of_day if params[:to_date].present?
    if params[:from_date].present? && params[:to_date].present?
      @internet_usages = InternetUsage.filter_with({from_date: @from_date, to_date: @to_date}).order(:created_at).page(params[:page]).per(30)
    else
      @internet_usages = InternetUsage.order(:created_at).page(params[:page]).per(30)
    end
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StudentInternetUsagesPdf.new(@internet_usages, @student_id, @from_date, @to_date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Usage Report.pdf"
      end
    end
  end
end