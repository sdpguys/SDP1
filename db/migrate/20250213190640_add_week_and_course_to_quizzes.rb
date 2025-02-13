class AddWeekAndCourseToQuizzes < ActiveRecord::Migration[8.0]
  def change
    add_reference :quizzes, :week, foreign_key: true
    add_reference :quizzes, :course, foreign_key: true
  end
end
