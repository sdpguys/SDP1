class QuizzesController < ApplicationController
  def generate
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    week = Week.find(params[:week_id])
    @topic = week.content.presence || "General Knowledge"

    # Desired total quiz questions
    total_questions_needed = 10

    # Fetch existing DB questions for this week
    database_questions = Quizzesthat.where(week: week).order("RANDOM()").limit(5).to_a

    # Calculate how many more to generate
    remaining_questions_needed = total_questions_needed - database_questions.size

    Rails.logger.debug "Found #{database_questions.size} existing questions. " \
                       "Need #{remaining_questions_needed} more for week #{week.id}."

    generated_questions = []

    # Generate only if we still need more
    if remaining_questions_needed.positive?
      Rails.logger.debug "Generating #{remaining_questions_needed} new question(s)."

      remaining_questions_needed.times do |i|
        begin
          Rails.logger.debug("OpenAI request for question #{i+1} of #{remaining_questions_needed}")

          # Make OpenAI API call
          response = client.chat(
            parameters: {
              model: "gpt-3.5-turbo",
              messages: [
                {
                  role: "system",
                  content: <<~PROMPT
                    You are a quiz generator. Generate 1 multiple-choice question about #{@topic}.
                    Format must be:
                    1) Question text
                    2) A blank line
                    3) Four lines: A), B), C), D)
                    4) A blank line
                    5) Correct Answer: X (X in [A,B,C,D])
                  PROMPT
                },
                {
                  role: "user",
                  content: "Generate the question now."
                }
              ],
              temperature: 0.7
            }
          )

          # Parse GPT response
          question_text = response.dig("choices", 0, "message", "content")

          if question_text.present?
            lines = question_text.strip.split("\n")
            question_line = lines[0]
            option_lines  = lines[2..5] || []
            answer_line   = lines[7]

            # Validate minimal format
            if question_line.blank? || option_lines.size < 4 || answer_line.blank?
              Rails.logger.error "Malformed GPT response, skipping question."
              next
            end

            correct_answer = answer_line.split(":").last&.strip
            unless correct_answer&.match?(/\A[ABCD]\z/i)
              Rails.logger.error "Invalid correct answer '#{correct_answer}', skipping."
              next
            end

            # Create the question in DB
            new_question = Quizzesthat.create!(
              question: question_line,
              answer: correct_answer,
              options: option_lines.to_json,
              week: week,
              course: week.course
            )

            Rails.logger.debug("Created Quizzesthat ID=#{new_question.id}")
            generated_questions << new_question
          else
            Rails.logger.error "Empty GPT response."
          end

        rescue => e
          Rails.logger.error("Error creating question: #{e.message}")
          next
        end
      end
    else
      Rails.logger.debug "No new questions needed; DB already has enough."
    end

    # Combine existing + newly generated
    @questions = (database_questions + generated_questions).shuffle

    Rails.logger.debug "Final question count: #{@questions.size}"

    # Render or redirect to a quiz view
    render "quizzes/download_quiz"
  end
end
