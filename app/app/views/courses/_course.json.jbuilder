json.extract! course, :id, :course_name, :course_instructor, :course_grading, :course_yourgrade, :course_notes, :created_at, :updated_at
json.url course_url(course, format: :json)
