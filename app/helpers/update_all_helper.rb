module UpdateAllHelper

  def update_array_attr(collection, attr)
    get = attr.to_sym
    set = "#{attr}=".to_sym
    to_add = params["#{attr}_add".to_sym]
    to_remove = params["#{attr}_remove".to_sym]
    return unless to_add.blank? && to_remove.blank?
    collection.each do |model|
      ids = model.send(get)
      ids = (ids + to_add).uniq
      ids = ids - to_remove
      model.send(set, ids)
    end
  end
  
end
