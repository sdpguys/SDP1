class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :course_name
      t.string :course_instructor
      t.string :course_grading
      t.string :course_yourgrade
      t.string :course_notes

      t.timestamps
    end
  end
end
