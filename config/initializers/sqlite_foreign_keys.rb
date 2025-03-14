ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON;")
  end
  