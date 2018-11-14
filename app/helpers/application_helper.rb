module ApplicationHelper

  def text_color(color)
    (luminance(color) > 186) ? '#000000' : '#ffffff'
  end

  def luminance(color)
    red = color[1,3].to_i
    green = color[3,5].to_i
    blue = color[5,7].to_i
    (red * 0.299 + green * 0.587 + blue * 0.114)
  end

end
