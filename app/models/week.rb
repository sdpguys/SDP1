class Week < ApplicationRecord
  belongs_to :course
  has_many_attached :files  # Ensure you have `has_many_attached` and not `has_one_attached`
  has_many :quizzes, dependent: :destroy
end
