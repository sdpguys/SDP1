class CreateQuizzestheres < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzestheres do |t|
      t.string :question
      t.text :options, default:""
      t.string :answer, default:""
      t.references :week,  foreign_key: true
      t.references :course,  foreign_key: true

      t.timestamps
    end
  end
end
