class Quiz < ApplicationRecord
  validates :question, :answer, :options, presence: true

  # Store the options as a JSON string in the database
  def options=(value)
    super(value.is_a?(Array) ? value.to_json : value)
  end

  def options
    JSON.parse(super || '[]') # Ensure it defaults to an empty array if nil
  end
end
