class FixForeignKeyConstraintsForWeeks < ActiveRecord::Migration[8.0]
  def change
    # Fixing the foreign key on quizzes
    remove_foreign_key :quizzes, :weeks
    add_foreign_key :quizzes, :weeks, on_delete: :cascade

    # Fixing the foreign key on quizzesthats
    remove_foreign_key :quizzesthats, :weeks
    add_foreign_key :quizzesthats, :weeks, on_delete: :cascade
  end
end
