class AdvicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @advices = current_user.advices.order(created_at: :desc)
  end

  def new
    @advice = Advice.new
  end

  def create
    @advice = current_user.advices.build(advice_params)
    if @advice.save
      response = fetch_openai_advice(@advice.input)
      @advice.update(response: response)
      redirect_to @advice, notice: "AIコーチアからアドバイスを受けました。"
    else
      render :new
    end
  end

  def show
    @advice = Advice.find(params[:id])
  end

  private

  def advice_params
    params.require(:advice).permit(:input)
  end

  def fetch_openai_advice(question)
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
