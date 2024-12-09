class AddWeekNumberToWeeks < ActiveRecord::Migration[8.0]
  def change
    add_column :weeks, :week_number, :integer
  end
end
