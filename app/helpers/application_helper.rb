module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-[#8DBA30]"
    when :alert  then "bg-[#f84c08]"
    when :error  then "bg-[#f6b827]"
    else "bg-gray-500"
    end
  end
end
