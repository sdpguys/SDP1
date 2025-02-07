class QuizzesController < ApplicationController
  require "openai"

  def generate
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"]) # Use environment variable for security

    @topic = params[:topic] || "Ada University" # Default topic if none is provided
    @questions = []

    3.times do
      response = client.chat(
        parameters: {
          model: "gpt-4", # or "gpt-3.5-turbo"
          messages: [
            { role: "system", content: "You are a quiz generator. Generate a single multiple-choice question on the topic: #{@topic}. Provide four answer choices (A, B, C, D), and indicate the correct answer at the end." },
            { role: "user", content: "Generate one multiple-choice question on #{@topic} with answer choices and mark the correct one." }
          ],
          temperature: 0.7
        }
      )

      question_text = response.dig("choices", 0, "message", "content")

      if question_text
        match = question_text.match(/^(?<question>.*?)\nA\.\s(?<a>.*?)\nB\.\s(?<b>.*?)\nC\.\s(?<c>.*?)\nD\.\s(?<d>.*?)\nCorrect Answer:\s(?<correct>[A-D])/m)

        if match
          @questions << {
            question: match[:question],
            choices: {
              "A" => match[:a],
              "B" => match[:b],
              "C" => match[:c],
              "D" => match[:d]
            },
            correct: match[:correct]
          }
        end
      end
    end

    render "generate_quiz"
  end
end
