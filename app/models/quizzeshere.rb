class Quizzeshere < ApplicationRecord
  belongs_to :week
  belongs_to :course

  validates :question, :answer, :options, presence: true

  # Store options as a JSON object
  def options=(value)
    super(value.is_a?(Array) ? value.to_json : value)
  end

  def options
    JSON.parse(super || '[]')
  end
end
