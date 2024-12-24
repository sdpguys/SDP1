class QuizzesController < ApplicationController
  require "nokogiri"

  def submit
    uploaded_file = params[:quizFile]
    if uploaded_file
      # Parse the uploaded HTML
      html_content = uploaded_file.read
      doc = Nokogiri::HTML(html_content)

      # Extract questions and answers
      questions = doc.css(".question")
      results = []

      questions.each do |question|
        correct_option = question.css('[data-correct="true"]').text
        selected_option = params["question_#{question['id']}"]
        results << { question: question.text, correct: correct_option, selected: selected_option }
      end

      # Check answers
      score = results.count { |result| result[:correct] == result[:selected] }
      render json: { results: results, score: score }
    else
      redirect_to root_path, alert: "No file uploaded."
    end
  end
end
