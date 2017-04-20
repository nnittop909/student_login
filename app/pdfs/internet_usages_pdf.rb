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
    footer
  end

  def set_date
    if (@from_date && @to_date).present?
      if @from_date.strftime("%d") == @to_date.strftime("%d")
        @to_date.strftime("%B %d, %Y")
      elsif @from_date.strftime("%d") != @to_date.strftime("%d") || @from_date.strftime("%B") != @to_date.strftime("%B")
        @from_date.strftime("%B %d, %Y") +" - "+ @to_date.strftime("%B %d, %Y")
      end
    else
      @internet_usages.first.created_at.strftime("%B %d, %Y") +" - "+ @internet_usages.last.created_at.strftime("%B %d, %Y")
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

  def filtered_1
    if @course_id.present?
      Student.all.each do |student|
        student.internet_usages.where('created_at' => @from_date..@to_date).where('course_id' => @course_id)
      end
    elsif @course_id.present? && @year_level_id.present?
      InternetUsage.where('course_id' => @course_id).where('year_level_id' => @year_level_id).where('created_at' => @from_date..@to_date)
    elsif @course_id.blank? && @year_level_id.blank?
      @internet_usages
    end
  end

  def filtered
    if @course_id.present? && @year_level_id.present? && (@from_date && @to_date).present?
      @internet_usages.where('course_id' => @course_id).where('year_level_id' => @year_level_id).where('created_at' => @from_date.yesterday.end_of_day..@to_date.end_of_day)
    elsif @course_id.present? && @year_level_id.blank? && (@from_date && @to_date).present?
      @internet_usages.where('created_at' => @from_date.yesterday.end_of_day..@to_date.end_of_day).where('course_id' => @course_id)
    elsif @course_id.blank? && @year_level_id.blank? && (@from_date && @to_date).present?
      @internet_usages.where('created_at' => @from_date.yesterday.end_of_day..@to_date.end_of_day)
    elsif @course_id.blank? && @year_level_id.blank? && (@from_date && @to_date).blank?
      @internet_usages
    end
  end

  def display_usage_table
    if @internet_usages.blank?
      move_down 10
      text "No internet usages data.", align: :center
    else
      if (@from_date && @to_date).present?
        if @from_date.strftime("%d") == @to_date.strftime("%d")
          table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: [155, 80, 80, 80, 80, 80 ]) do
            row(0).font_style = :bold
          # /  row(0).background_color = 'DDDDDD'

            row(-1).font_style = :bold
            row(-1).size = 11
          end
        else
          table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: [100, 120, 70, 70, 70, 70, 70 ]) do
            row(0).font_style = :bold
          # /  row(0).background_color = 'DDDDDD'

            row(-1).font_style = :bold
            row(-1).size = 11
          end
        end
      else
        table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: [100, 120, 70, 70, 70, 70, 70 ]) do
            row(0).font_style = :bold
          # /  row(0).background_color = 'DDDDDD'

            row(-1).font_style = :bold
            row(-1).size = 11
          end
      end
      move_down 10
      
    end
  end

  def table_data
    move_down 5
    if (@from_date && @to_date).present?
      if @from_date.strftime("%d") == @to_date.strftime("%d")
        [["STUDENT", "TIME IN", "TIME OUT", "CONSUMED", "REMAINING", "EXCESS"]] +
        @table_data ||= filtered.map { |e| [e.student.full_name, e.time_in.strftime("%I:%M%p"), e.time_out.strftime("%I:%M%p"), e.usage_in_time_format, e.student.internet_usages.total_remaining, e.student.internet_usages.excess]} +
        [["", "", "", "", "", ""]]
      else
        [["DATE", "STUDENT", "TIME IN", "TIME OUT", "CONSUMED", "REMAINING", "EXCESS"]] +
        @table_data ||= filtered.map { |e| [e.created_at.strftime("%B %d, %Y"), e.student.full_name, e.time_in.strftime("%I:%M%p"), e.time_out.strftime("%I:%M%p"), e.usage_in_time_format, e.student.internet_usages.total_remaining, e.student.internet_usages.excess]} +
        [["", "", "", "", "", "", ""]]
      end
    else
      [["DATE", "STUDENT", "TIME IN", "TIME OUT", "CONSUMED", "REMAINING", "EXCESS"]] +
        @table_data ||= filtered.map { |e| [e.created_at.strftime("%B %d, %Y"), e.student.full_name, e.time_in.strftime("%I:%M%p"), e.time_out.strftime("%I:%M%p"), e.usage_in_time_format, e.student.internet_usages.total_remaining, e.student.internet_usages.excess]} +
        [["", "", "", "", "", "", ""]]
    end
  end

  def footer
    bounding_box([bounds.right - 130, bounds.bottom + 25], width: 120, height: 30) do
      text "#{User.admin.last.full_name.upcase}", size: 11, align: :center, font_style: :bold
      stroke_horizontal_rule
      move_down 5
      text "Internet Administrator", size: 10, align: :center
    end
  end
end