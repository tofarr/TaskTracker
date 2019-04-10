module ApplicationHelper

  def text_color(color)
    (luminance(color) > 186) ? '#000000' : '#ffffff'
  end

  def luminance(color)
    red = color[1,2].to_i(16)
    green = color[3,2].to_i(16)
    blue = color[5,2].to_i(16)
    (red * 0.299 + green * 0.587 + blue * 0.114)
  end

  def is_img(data)
    type = data.attachment && data.content_type
    type == "image/jpg" || type == "image/jpeg" || type == "image/gif" || type == "image/png"
  end

end
