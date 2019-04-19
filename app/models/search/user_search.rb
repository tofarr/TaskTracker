require "app_utils"

class Search::UserSearch < Struct.new(:ids, :query, :suspended, :admin, :tag_ids, :sort_order, :descending)

  def self.permitted_orders
    %w(username email name created_at updated_at)
  end

  def initialize(hash={})
    hash = AppUtils.collapse(hash)
    members.each { |a| send "#{a}=", hash[a] } unless hash.blank?
  end

  def search(current_user, force_order)
    hash = AppUtils.collapse(to_h.slice(:ids, :admin, :suspended))
    hash[:suspended] = false unless current_user.admin?
    users = User.where(hash)
    users = users.joins(:tags).where(user_tags: {id: tag_ids}) unless tag_ids.blank?
    users = users.where("username like ? or email like ? or name like ?", "%#{query}%", "%#{query}%", "%#{query}%") unless query.blank?
    if sort_order.present? && Search::UserSearch.permitted_orders.include?(sort_order.to_sym)
      order = {}
      order[sort_order.to_sym] = descending ? :desc : :asc
      users = users.send(:order, order)
    elsif force_order
      users = users.order(:username)
    end
    users
  end

  def default_search?(current_user)
    return false unless suspended.nil? || suspended == current_user.admin?
    return false unless to_h.slice(:ids, :admin, :tag_ids, :query).select { |k,v| v.present? }.blank?
    sort_order.blank? || (sort_order == 'username' && !descending)
  end
end
