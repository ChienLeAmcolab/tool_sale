# app/services/gpt_chat_service.rb

require 'openai'

class GptChatService
  def initialize(prompt)
    @prompt = prompt
    @client = OpenAI::Client.new
  end

  def call
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: system_message_content },
          { role: "user", content: @prompt }
        ],
        max_tokens: 3000,
        temperature: 0.85,
        top_p: 0.95
      }
    )
    parse_response(response)
  end

  private

  def parse_response(response)
    response.dig("choices", 0, "message", "content") || "No response received."
  end

  def system_message_content
    <<-SYSTEM
      You are an expert career consultant and job application writer. Your job is to help users craft thoughtful and creative responses to job applications. You should provide a detailed and convincing reply that shows a deep understanding of the job description, highlights relevant skills, and tailors the response to the specific role the user is applying for. Use a professional tone, but allow room for personal style, creativity, and enthusiasm. Encourage a compelling story where applicable.
    SYSTEM
  end
end
