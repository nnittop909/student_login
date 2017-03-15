class StudentInternetUsagesPdf < Prawn::Document
	TABLE_WIDTHS = [150, 150, 150, 100 ]
  def initialize(internet_usages, student_id, from_date, to_date, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @internet_usages = internet_usages
    @student_id = student_id
    @from_date = from_date
    @to_date = to_date
    @view_context = view_context
    @student = Student.find(@student_id)
    heading
    display_usage_table
  end

  def set_date
    if @from_date.strftime("%d") == @to_date.strftime("%d")
      @to_date.strftime("%B %d, %Y")
    elsif @from_date.strftime("%B") == @to_date.strftime("%B")
      @from_date.strftime("%B %Y")
    elsif @from_date.strftime("%d") != @to_date.strftime("%d") || @from_date.strftime("%B") != @to_date.strftime("%B")
      @from_date.strftime("%B %d, %Y") - @to_date.strftime("%B %d, %Y")
    end
  end

  def heading
  	text "Ifugao State University", size: 8, align: :center
  	text "Lagawe Campus", size: 8, align: :center
  	text "Lagawe, Ifugao", size: 8, align: :center
  	move_down 5
  	text 'Internet Usage Report', size: 10, align: :center
  	text set_date, size: 8, align: :center
    move_down 10
    table_title = [["Name: ", "#{@student.try(:full_name)}", "Total Used: ", "#{@student.internet_usages.total_time_consumption}"],
                  ["ID Number: ", "#{@student.id_number}", "Remaining: ", "#{@student.internet_usages.total_remaining}"],
                  ["Course/Year: ", "#{@student.course} - #{@student.year_level}", "Excess: ", "#{@student.internet_usages.excess}"]]
    table(table_title, :cell_style => {size: 9, :padding => [1, 1, 1, 1]}, column_widths: [80, 250, 150, 70]) do
      cells.borders = []
      column(1).font_style = :bold
      column(3).font_style = :bold
      column(2).align = :right
      column(3).align = :right
      column(4).align = :right
    end
  end

  def filtered
    if @student_id.present?
      InternetUsage.where('created_at' => @from_date..@to_date).where('student_id' => @student_id)
    elsif @student_id.blank?
      @internet_usages
    end
  end

  def display_usage_table
    if @internet_usages.blank?
      move_down 10
      text "No internet usages data.", align: :center
    else
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
    [["DATE", "TIME IN", "TIME OUT", "CONSUMED"]] +
    @table_data ||= filtered.map { |e| [e.time_in.strftime("%B %d, %Y"), e.time_in.strftime("%I:%M%p"), e.time_out.strftime("%I:%M%p"), e.usage_in_time_format]} +
    [["", "", "", ""]]
  end
end