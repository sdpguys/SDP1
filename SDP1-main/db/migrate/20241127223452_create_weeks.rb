class CreateWeeks < ActiveRecord::Migration[8.0]
  def change
    create_table :weeks do |t|
      t.string :title
      t.text :content
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
