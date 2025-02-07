class CreateQuizzes < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzes do |t|
      t.string :question
      t.string :answer
      t.text :options

      t.timestamps
    end
  end
end
