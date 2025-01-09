class OpenAiService
    def self.fetch_advice(question)
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
      prompt = <<~PROMPT
        あなたは爽やかで人間味のある経験豊富なランニングコーチです。
        以下の質問に対して、初心者にも分かりやすく、200文字程度で具体的なアドバイスをしてください。
        マークダウン記法は使わないでください。

        質問: #{question}

        アドバイス:
      PROMPT

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: "あなたは爽やかで人間味のある経験豊富なランニングコーチです。" },
            { role: "user", content: prompt }
          ],
          max_tokens: 500,
          temperature: 0.7
        }
      )

      response.dig("choices", 0, "message", "content").strip
    rescue StandardError => e
      Rails.logger.error("OpenAI APIエラー: #{e.message}")
      "現在AIコーチからアドバイスを受けることができません。後ほどお試しください。"
    end
end
