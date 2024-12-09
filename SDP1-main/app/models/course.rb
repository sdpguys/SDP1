class Course < ApplicationRecord
  has_many :weeks, dependent: :destroy
end
