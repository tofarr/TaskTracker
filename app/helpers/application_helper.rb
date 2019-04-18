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

  def bool_with_nil_opts(value, *labels)
    ret = [[labels[0],""],[labels[1],"0"],[labels[2],"1"]]
    index = if(value == 0 || value == "0")
              1
            elsif(value == 1 || value == "1")
              2
            else
              0
            end
    ret[index].insert(1, {selected: true})
    ret
  end

  def process_list(list, to_add, to_remove)
    list = (list + to_add).uniq if to_add.present?
    list = list - to_remove if to_remove.present?
    list
  end

end
