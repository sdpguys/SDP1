class QuizzesController < ApplicationController
  def generate
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    week = Week.find(params[:week_id])
    @topic = week.content.presence || "General Knowledge"

    total_questions_needed = 10
    database_questions = Quizzesthat.where(week: week).order("RANDOM()").limit(5).to_a
    remaining_questions_needed = total_questions_needed - database_questions.size

    generated_questions = []

    if remaining_questions_needed.positive?
      remaining_questions_needed.times do
        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [
              { role: "system", content: "You are a quiz generator. Generate a single multiple-choice question based on the topic: #{@topic}. Provide four answer choices (A, B, C, D). At the end, indicate the correct answer like this: Correct Answer: A/B/C/D. No other format is permitted for correct variant. NO space between variants. Example: Question,skip one line, four variants without skipping lines between them, skip one line, correct answer" },
              { role: "user", content: "Generate a multiple-choice question on #{@topic}." }
            ],
            temperature: 0.7
          }
        )

        question_text = response.dig("choices", 0, "message", "content")
        Rails.logger.debug("GPT Response: #{question_text}")

        if question_text
          question_lines = question_text.strip.split("\n")
          question = question_lines.first
          options = question_lines[2..5] || []
          correct_answer = question_lines.last.split(': ').last.strip

          new_question = Quizzesthat.create!(
            question: question,
            answer: correct_answer,
            options: options.to_json,
            week: week,
            course: week.course
          )

          generated_questions << new_question
        end
      end
    end

    @questions = (database_questions + generated_questions).shuffle

    render "quizzes/download_quiz"
  end
end
