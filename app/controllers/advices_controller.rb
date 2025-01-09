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
      # サービスクラスを利用してAIのアドバイスを取得
      advice_response = OpenAiService.fetch_advice(@advice.input)
      @advice.update(response: advice_response)
      redirect_to @advice, notice: "AIコーチからアドバイスを受けました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # 現在のユーザーに関連するアドバイスのみを表示
    @advice = current_user.advices.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to advices_path, alert: "指定されたアドバイスは見つかりませんでした。"
  end

  private

  def advice_params
    params.require(:advice).permit(:input)
  end
end
