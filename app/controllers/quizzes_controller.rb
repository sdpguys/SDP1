def generate
  client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

  # Find the week record
  week = Week.find(params[:week_id])

  # Use the week.content as the main topic or text to generate questions about
  lesson_text = week.content.presence || "General Knowledge"

  Rails.logger.debug "Generating quiz for Week ID=#{week.id} with content: #{lesson_text.inspect}"

  # Decide how many total questions you want
  total_questions_needed = 10

  # Fetch existing DB questions for this week
  database_questions = Quizzesthat.where(week: week).order("RANDOM()").limit(5).to_a
  remaining_questions_needed = total_questions_needed - database_questions.size

  generated_questions = []

  if remaining_questions_needed.positive?
    remaining_questions_needed.times do
      begin
        # Make a request to GPT, passing the lesson_text as context
        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [
              {
                role: "system",
                content: <<~PROMPT
                  You are a quiz generator. Create exactly ONE multiple-choice question based on the following content:

                  "#{lesson_text}"

                  FORMAT:
                  1) One line with the question text.
                  2) A blank line.
                  3) Four lines labeled A), B), C), D) with possible answers.
                  4) A blank line.
                  5) "Correct Answer: X" (X is A, B, C, or D).

                  No extra text or commentary. Just follow the format strictly.
                PROMPT
              },
              {
                role: "user",
                content: "Generate the quiz question now."
              }
            ],
            temperature: 0.7
          }
        )

        question_text = response.dig("choices", 0, "message", "content")
        Rails.logger.debug("GPT response for Week #{week.id}: #{question_text}")

        # Parse the response (similar logic as before)
        if question_text.present?
          lines = question_text.strip.split("\n")
          question_line = lines[0]
          option_lines  = lines[2..5] || []
          answer_line   = lines[7]

          # Minimal validation checks
          if question_line.blank? || option_lines.size < 4 || answer_line.blank?
            Rails.logger.error "Malformed GPT response for week #{week.id}, skipping."
            next
          end

          correct_answer = answer_line.split(":").last&.strip
          unless correct_answer&.match?(/\A[ABCD]\z/i)
            Rails.logger.error "Invalid correct answer '#{correct_answer}', skipping."
            next
          end

          # Create the question in the DB
          new_question = Quizzesthat.create!(
            question: question_line,
            answer: correct_answer,
            options: option_lines.to_json,
            week: week,
            course: week.course
          )

          generated_questions << new_question
        else
          Rails.logger.error "Empty GPT response for week #{week.id}, skipping."
        end

      rescue => e
        Rails.logger.error("Error generating question for week #{week.id}: #{e.message}")
        next
      end
    end
  end
<<<<<<< HEAD

  @questions = (database_questions + generated_questions).shuffle
  render "quizzes/download_quiz"
=======
  def results
    @courses = Course.all
    @weeks=Week.all
    @quiz_results = QuizResult.includes(week: :course).where(user: current_user)
  
    # Filter by week title if provided
    @quiz_results = @quiz_results.where(week: { title: params[:week_title] }) if params[:week_title].present?
  
    # Filter by course name if provided
    @quiz_results = @quiz_results.where(week: { course: { course_name: params[:course_name] } }) if params[:course_name].present?
  
    @quiz_results = @quiz_results.order(created_at: :desc)
  end
  
  
  def submit_results
    user = User.find(params[:user_id]) # Assuming user authentication exists
    week = Week.find(params[:week_id])
    score = params[:score]
    total_questions = params[:total_questions]

    quiz_result = QuizResult.create!(
      user: user,
      week: week,
      score: score,
      total_questions: total_questions
    )

    render json: { message: "Result saved successfully!", result: quiz_result }, status: :ok
  end
>>>>>>> 0a844e0f186a74a7d160222787a8a0f47e451028
end
