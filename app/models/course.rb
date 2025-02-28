class Course < ApplicationRecord
  has_many :weeks, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :quizzes, dependent: :destroy
  validates :course_name, presence: true
end
