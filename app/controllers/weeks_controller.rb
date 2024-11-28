class WeeksController < ApplicationController
  before_action :set_course
  before_action :set_week, only: [ :edit, :update, :destroy ]

  def new
    @week = @course.weeks.build
  end

  def create
    @week = @course.weeks.build(week_params)
    if @week.save
      redirect_to course_path(@course), notice: "Week added successfully!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @week.update(week_params)
      redirect_to course_path(@course), notice: "Week updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @week.destroy
    redirect_to course_path(@course), notice: "Week deleted successfully."
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_week
    @week = @course.weeks.find(params[:id])
  end

  def week_params
    params.require(:week).permit(:title, :content, files: [])
  end
end
