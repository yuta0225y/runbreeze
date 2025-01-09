require 'rails_helper'
require 'webmock/rspec'
require Rails.root.join('app/services/open_ai_service')

RSpec.describe OpenAiService, type: :service do
  before do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 200,
        body: {
          choices: [
            { message: { content: "ランニング初心者には無理をしないことが大切です。" } }
          ]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe '.fetch_advice' do
    it '正しいリクエストを送信し、AIの回答を取得する' do
      question = "ランニングのコツを教えてください"
      response = OpenAiService.fetch_advice(question)

      expect(response).to eq("ランニング初心者には無理をしないことが大切です。")

      expect(WebMock).to have_requested(:post, "https://api.openai.com/v1/chat/completions") do |req|
        body = JSON.parse(req.body)
        messages = body["messages"]
        expect(messages.any? { |m| m["content"].include?("ランニングのコツを教えてください") }).to be_truthy
      end
    end

    it 'APIエラー時に適切なメッセージを返す' do
      stub_request(:post, "https://api.openai.com/v1/chat/completions")
        .to_return(status: 500, body: '')

      response = OpenAiService.fetch_advice("エラーケース")
      expect(response).to eq("現在AIコーチからアドバイスを受けることができません。後ほどお試しください。")
    end
  end
end
