class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @available_courses = Course.where.not(id: current_user.courses.pluck(:id))  # Exclude courses the user has taken
    @taken_courses = current_user.courses                                       # Show the user's taken courses
  end
end
