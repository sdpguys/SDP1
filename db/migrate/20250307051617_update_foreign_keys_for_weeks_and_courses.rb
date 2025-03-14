class UpdateForeignKeysForWeeksAndCourses < ActiveRecord::Migration[6.1]
  def change
    # Remove existing foreign keys
    remove_foreign_key :weeks, :courses
    remove_foreign_key :quizzes, :weeks

    # Add new foreign keys with CASCADE delete
    add_foreign_key :weeks, :courses, on_delete: :cascade
    add_foreign_key :quizzes, :weeks, on_delete: :cascade
  end
end
