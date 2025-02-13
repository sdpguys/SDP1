class CreateQuizzesheres < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzesheres do |t|
      t.string :question
      t.text :options
      t.string :answer
      t.references :week, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
