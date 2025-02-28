class CreateQuizResults < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :week, null: false, foreign_key: true
      t.integer :score
      t.integer :total_questions

      t.timestamps
    end
  end
end
