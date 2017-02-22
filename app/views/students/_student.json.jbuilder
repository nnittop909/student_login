json.extract! student, :id, :first_name, :last_name, :middle_name, :gender, :id_number, :address, :course, :year_level, :created_at, :updated_at
json.url student_url(student, format: :json)