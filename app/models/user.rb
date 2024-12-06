class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         scope :admins, -> { where(admin: true) }

         # Method to check if the user is an admin
         def admin?
           self.admin
         end

end
