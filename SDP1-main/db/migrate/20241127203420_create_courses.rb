class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :course_name
      t.string :course_instructor
      t.string :course_grading_criteria
      t.string :courses_your_grade
      t.string :course_comments

      t.timestamps
    end
  end
end
