class QuizzesController < ApplicationController
  require "openai"

  def generate
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    week = Week.find(params[:week_id])
    @topic = week.content.presence || "General Knowledge" # Use content as topic
    @questions = []

    10.times do  
      response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [
            { role: "system", content: "You are a quiz generator. Generate a single multiple-choice question based on the topic: #{@topic}. Generate 10 different questions on your own but do not show all of them, pick one of them only and send me.Theorotical or Mathematical. Provide four answer choices (A, B, C, D). At the end, indicate the correct answer like this: Correct Answer: A/B/C/D. No other format is permitted for correct variant" },
            { role: "user", content: "Generate a multiple-choice question on #{@topic}." }
          ],
          temperature: 0.7
        }
      )

      question_text = response.dig("choices", 0, "message", "content")
      Rails.logger.debug("GPT Response: #{question_text}")

      @questions << question_text.strip if question_text
    end

    download_quiz
  end

  def download_quiz
    html_content = render_to_string(template: "quizzes/download_quiz", layout: false)

    send_data html_content, filename: "quiz.html", type: "text/html"
  end
end
