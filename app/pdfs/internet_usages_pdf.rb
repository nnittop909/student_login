class InternetUsagesPdf < Prawn::Document
	TABLE_WIDTHS = [100, 120, 70, 70, 70, 70, 70 ]
  def initialize(internet_usages, course_id, year_level_id, from_date, to_date, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @internet_usages = internet_usages
    @course_id = course_id
    @year_level_id = year_level_id
    @from_date = from_date
    @to_date = to_date
    @view_context = view_context
    heading
    display_usage_table
  end

  def set_date
    if @from_date.strftime("%d") == @to_date.strftime("%d")
      @to_date.strftime("%B %d, %Y")
    elsif @from_date.strftime("%d") != @to_date.strftime("%d") || @from_date.strftime("%B") != @to_date.strftime("%B")
      @from_date.strftime("%B %d, %Y") +" - "+ @to_date.strftime("%B %d, %Y")
    end
  end

  def set_course_and_year_level
    if @course_id.present?
      "#{Course.find(@course_id).name}"
    elsif @year_level_id.present?
      "#{YearLevel.find(@year_level_id).name}"
    elsif @course_id.present? && @year_level_id.present?
      "#{Course.find(@course_id).name} - #{YearLevel.find(@year_level_id).name}"
    else
      ""
    end
  end

  def heading
  	text "Ifugao State University", size: 8, align: :center
  	text "Lagawe Campus", size: 8, align: :center
  	text "Lagawe, Ifugao", size: 8, align: :center
  	move_down 5
  	text 'Internet Usage Report', size: 10, align: :center
    text set_course_and_year_level, size: 9, align: :center
  	text set_date, size: 9, align: :center
  end

  def filtered
    if @course_id.present?
      InternetUsage.where('created_at' => @from_date..@to_date).where('course_id' => @course_id)
    elsif @course_id.present? && @year_level_id.present?
      InternetUsage.where('course_id' => @course_id).where('year_level_id' => @year_level_id).where('created_at' => @from_date..@to_date)
    elsif @course_id.blank? && @year_level_id.blank?
      @internet_usages
    end
  end

  def display_usage_table
    if @internet_usages.blank?
      move_down 10
      text "No internet usages data.", align: :center
    else
      move_down 10
      table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        row(0).font_style = :bold
      # /  row(0).background_color = 'DDDDDD'

        row(-1).font_style = :bold
        row(-1).size = 11
      end
    end
  end

  def table_data
    move_down 5
    [["DATE", "STUDENT", "TIME IN", "TIME OUT", "CONSUMED", "REMAINING", "EXCESS"]] +
    @table_data ||= filtered.map { |e| [e.time_in.strftime("%B %d, %Y"), e.student.full_name, e.time_in.strftime("%I:%M%p"), e.time_out.strftime("%I:%M%p"), e.usage_in_time_format, e.student.internet_usages.total_remaining, e.student.internet_usages.excess]} +
    [["", "", "", "", "", "", ""]]
  end
end