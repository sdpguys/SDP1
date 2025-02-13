class QuizzesController < ApplicationController
  require "openai"

  def generate
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    week = Week.find(params[:week_id])
    @topic = week.content.presence || "General Knowledge" # Use content as topic
    @questions = []

    # Loop to generate 5 questions
    5.times do
      response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [
            { role: "system", content: "You are a quiz generator. Generate a single multiple-choice question based on the topic: #{@topic}. Divide the topic to 10 detailed types randomly pick one of them only and send me.Theoretical or Mathematical. Provide four answer choices (A, B, C, D). At the end, indicate the correct answer like this: Correct Answer: A/B/C/D. No other format is permitted for correct variant. NO space between variants" },
            { role: "user", content: "Generate a multiple-choice question on #{@topic}." }
          ],
          temperature: 0.7
        }
      )

      question_text = response.dig("choices", 0, "message", "content")
      Rails.logger.debug("GPT Response: #{question_text}")

      if question_text
        # Save the generated question in the database
        question_lines = question_text.strip.split("\n")

        # Assuming that each question has a structure similar to:
        # Question text
        # Answer choices (A, B, C, D)
        # Correct Answer indicator
        question = question_lines.first
        options = question_lines[2..5]
        correct_answer = question_lines.last.split(': ').last.strip

        # Create and save the quiz in the database
        Quizzeshere.create!(
          question: question,
          answer: correct_answer,
          options: options,
          week: week,
          course: week.course
        )

        # Store the question in @questions to be rendered in the quiz download
        @questions << question_text.strip
      end
    end

    download_quiz
  end

  def download_quiz
    html_content = render_to_string(template: "quizzes/download_quiz", layout: false)

    send_data html_content, filename: "quiz.html", type: "text/html"
  end
end
