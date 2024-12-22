class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
         scope :admins, -> { where(admin: true) }
         has_many :user_courses
         has_many :courses, through: :user_courses
         has_many :notifications, dependent: :destroy
         # Method to check if the user is an admin
         def admin?
           self.admin
         end

end
