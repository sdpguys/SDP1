json.extract! course, :id, :course_name, :course_instructor, :course_grading_criteria, :courses_your_grade, :course_comments, :created_at, :updated_at
json.url course_url(course, format: :json)
