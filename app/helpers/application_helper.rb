module ApplicationHelper
  def flash_background_class(type)
    case type.to_sym
    when :notice then "alert-info"
    when :success then "alert-success"
    when :alert  then "alert-error"
    when :warning then "alert-warning"
    end
  end
end
