class AddCascadeDeleteToCourses < ActiveRecord::Migration[8.0]
  def change
    # Remove existing foreign key constraints
    remove_foreign_key :quizzes, :courses
    remove_foreign_key :quizzesthats, :courses
    remove_foreign_key :user_courses, :courses
    remove_foreign_key :weeks, :courses

    # Add new foreign keys with ON DELETE CASCADE
    add_foreign_key :quizzes, :courses, on_delete: :cascade
    add_foreign_key :quizzesthats, :courses, on_delete: :cascade
    add_foreign_key :user_courses, :courses, on_delete: :cascade
    add_foreign_key :weeks, :courses, on_delete: :cascade
  end
end
