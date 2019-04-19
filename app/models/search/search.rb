require "app_utils"

class Search::Search < Struct.new(:query, :sort_order, :descending)

  def self.permitted_orders
    %w(title created_at updated_at)
  end

  def initialize(hash={})
    hash = AppUtils.collapse(hash)
    members.each { |a| send "#{a}=", hash[a] } unless hash.blank?
  end

  def filter(results, force_order)
    results = results.where('title like ?', "%#{query}%")
    if sort_order.present? && Search::Search.permitted_orders.include?(sort_order.to_sym)
      order = {}
      order[sort_order.to_sym] = descending ? :desc : :asc
      results = results.send(:order, order)
    elsif force_order
      results = results.order(:title)
    end
    results
  end

  def default_search?(current_user)
    return false if query.present?
    sort_order.blank? || ((sort_order == 'title') && !descending)
  end
end
