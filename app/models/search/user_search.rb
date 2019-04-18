require "app_utils"

class Search::UserSearch < Struct.new(:ids, :query, :order, :suspended, :admin, :tag_ids)

  def self.permitted_orders
    %w(username email name created_at updated_at)
  end

  def initialize(hash={})
    puts "TRACE:init:1:#{hash}"
    hash = AppUtils.collapse(hash)
    puts "TRACE:init:2:#{hash}"
    members.each { |a| send "#{a}=", hash[a] } unless hash.blank?
  end

  def search(current_user, force_order)
    hash = AppUtils.collapse(to_h.slice(:ids, :admin, :suspended))
    hash[:suspended] = false unless current_user.admin?
    users = User.where(hash)
    users = users.joins(:tags).where(user_tags: {id: tag_ids}) unless tag_ids.blank?
    users = users.where("username like ? or email like ? or name like ?", "%#{query}%", "%#{query}%", "%#{query}%") unless query.blank?
    users = users.order(order) if order.present? && Search::UserSearch.permitted_orders.include?(order.to_sym)
    users
  end

  def default_search?(current_user)
    return false unless suspended.nil? || suspended == current_user.admin?
    return false unless to_h.slice(:ids, :admin, :tag_ids, :query).select { |k,v| v.present? }.blank?
    order.blank? || order == 'username'
  end
end
