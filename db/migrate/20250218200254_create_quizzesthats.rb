class CreateQuizzesthats < ActiveRecord::Migration[6.1]
  def change
    create_table :quizzesthats do |t|
      t.text :question, null: false
      t.text :options, default: [].to_json
      t.string :answer, null: false
      t.references :week, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
