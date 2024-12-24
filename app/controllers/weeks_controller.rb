class WeeksController < ApplicationController
  before_action :set_week, only: [ :edit, :update, :destroy, :generate_quiz ]
  before_action :set_course, only: [ :edit, :update, :destroy, :generate_quiz ]

  def new
    @week = @course.weeks.build
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
    @week = Week.find(params[:id])
    @content = @week.content
    render template: "weeks/quiz_instruction"
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
    @week = @course.weeks.find(params[:id])
  end

  def update
    @week = @course.weeks.find(params[:id])
    if @week.update(week_params)
      redirect_to course_path(@course), notice: "Week updated successfully!"
    else
      render :edit
    end
  end
  def show
    @week = @course.weeks.find(params[:id])
  end



  def destroy
    @week = @course.weeks.find(params[:id])
    @week.destroy
    redirect_to course_path(@course), notice: "Week deleted successfully."
  end


  private

  def set_week
    @week = Week.find(params[:id]) # Directly find the Week by ID
  end

  def set_course
    @course = @week.course # Fetch the Course from the Week
  end


  def week_params
    params.require(:week).permit(:title, :content, files: [])
  end
end
