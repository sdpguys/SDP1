class UserCoursesController < ApplicationController
    before_action :authenticate_user!
  
    # Add a course to the user's taken courses
    def create
      course = Course.find(params[:course_id])
      unless current_user.courses.include?(course)
        current_user.courses << course
        redirect_to dashboard_path, notice: "Course successfully added to your list."
      else
        redirect_to dashboard_path, alert: "You have already taken this course."
      end
    end
  
    # Remove a course from the user's taken courses
    def destroy
      user_course = current_user.user_courses.find_by(course_id: params[:id])
      if user_course
        user_course.destroy
        redirect_to dashboard_path, notice: "Course successfully removed from your list."
      else
        redirect_to dashboard_path, alert: "Course not found in your list."
      end
    end
  end
  