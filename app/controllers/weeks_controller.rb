class WeeksController < ApplicationController
  before_action :set_course, only: [ :new, :create, :edit, :update, :destroy, :show ]
  before_action :set_week, only: [ :edit, :update, :destroy, :generate_quiz_html, :show ]

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

  def edit; end

  def update
    if @week.update(week_params)
      redirect_to course_path(@course), notice: "Week updated successfully!"
    else
      render :edit
    end
  end

  def show; end

  def destroy
    # Delete any dependent records that reference this week
    @week.quizzes.destroy_all if @week.quizzes.any?
    # You can also add other dependent models here
    @week.destroy
    redirect_to course_path(@course), notice: "Week deleted successfully."
  rescue ActiveRecord::InvalidForeignKey
    render "errors/foreign_key_error", status: :unprocessable_entity
  
  end
  

  def generate_quiz
    puts "API Key: #{ENV['OPENAI_API_KEY']}"

    client = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"])

    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "You are a helpful assistant that generates quizzes." },
            { role: "user", content: "Generate a 10-question multiple-choice quiz based on the following content:\n\n#{@week.content}" }
          ]
        }
      )
      puts "OpenAI Response: #{response.inspect}"
    rescue StandardError => e
      puts "Error: #{e.message}"
      render plain: "Error: #{e.message}"
    end
  end

  def generate_quiz_html
    @content = @week.content
    render template: "weeks/quiz_instruction"
  end

  private

  def set_course
    @course = Course.find_by(id: params[:course_id])
    if @course.nil?
      redirect_to courses_path, alert: "Course not found."
    end
  end

  def set_week
    @week = Week.find_by(id: params[:id])
    if @week.nil?
      redirect_to courses_path, alert: "Week not found."
    end
  end

  def week_params
    params.require(:week).permit(:title, :content, files: [])
  end
end
