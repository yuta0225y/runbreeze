module ApplicationHelper
  def flash_background_class(type)
    case type.to_sym
    when :notice then "alert-info"
    when :success then "alert-success"
    when :alert  then "alert-error"
    when :warning then "alert-warning"
    end
  end

  def category_image_filename(category_name)
    mapping = {
      "ゆるっとラン" => "yurutto_run.svg",
      "トレーニング" => "training.svg",
      "栄養"       => "nutrition.svg",
      "ギア"       => "gear.svg",
      "イベント"   => "event.svg",
      "健康"       => "health.svg",
      "マインド"   => "mind.svg",
      "コラム"     => "column.svg"
    }
    mapping[category_name] || "default_post_image.jpg"
  end

  # アセットの存在を確認するヘルパー
  def asset_exists?(path)
    if Rails.configuration.assets.compile
      Rails.application.assets.find_asset(path).present?
    else
      Rails.application.assets_manifest.find_sources(path).present?
    end
  rescue
    false
  end
end
