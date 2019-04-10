class ChartsController < ApplicationController

  include ChartsHelper
  helper_method :project
  helper_method :project_x
  helper_method :project_y

  def status_pie
    task_search = TaskSearch.get_search(current_user, params)
    status_counts = task_search.search(current_user).group(:status_id).count
    @num_statuses = status_counts.values.sum
    @task_statuses = TaskStatus.select("task_statuses.*, 0 as count").find(status_counts.keys).map do |status|
      status.assign_attributes(count: status_counts[status.id])
      status
    end
  end

  #This is based on the burndown chart, so may be slow!
  def burndown_line

    task_search = TaskSearch.get_search(current_user, params)

    #Status counts as of right now...
    @task_statuses = TaskStatus.all
    @task_statuses = @task_statuses.where(id: params[:task_status_ids]) if params[:task_status_ids]
    status_counts = task_search.search(current_user)
    status_counts = status_counts.where(task_status_id: params[:task_status_ids]) if params[:task_status_ids]
    status_counts = status_counts.group(:status_id).count
    @task_statuses.each do |task_status|
      status_counts[task_status.id] = 0 unless status_counts[task_status.id]
    end

    #We get all ids that correspond to this too...
    task_ids = task_search.search(current_user).select(:id).map(&:id)

    @start_date = params[:start_date] ? DateTime.parse(params[:start_date]) : DateTime.now - 7.days
    @end_date = params[:end_date] ? DateTime.parse(params[:end_date]) : DateTime.now

    #build a range of values for the graph based on the status counts for right now...
    @chart_dates = (@start_date..@end_date).map do |date|
      {
        date: date,
        values: status_counts.clone
      }
    end

    #Work backwards from today...
    ActivityLog.where('created_at >= ?', @start_date).where(model_type: 'Task', model_id: task_ids).each do |activity_log|
      deltas = deltas(activity_log)
      next unless deltas
      @chart_dates.each do |chart_date|
        next if chart_date[:date] >= activity_log.created_at
        values = char_date[:values]
        deltas.each do |k,v|
          values[k] -= v unless values[k].nil?
        end
      end
    end

    #get a min and max
    @min = 0 #min(@chart_dates)
    @max = max(@chart_dates)

    x_values(@chart_dates, @start_date)
    y_values(@chart_dates, @min, @max)

  end

  private

    def deltas(activity_log)
      case activity_log.action
      when 'DELETE'
        delete_deltas(activity_log.updates)
      when 'UPDATE'
        update_deltas(activity_log.updates)
      when 'CREATE'
        create_deltas(activity_log.updates)
      end
    end

    def delete_deltas(updates)
      deltas = {}
      deltas[updates["task_id"]] = -1
      deltas
    end

    def update_deltas(updates)
      task_changes = updates["task_id"]
      return nil unless task_changes
      deltas = {}
      deltas[updates[0]] = -1
      deltas[updates[1]] = 1
      deltas
    end

    def create_deltas(updates)
      deltas = {}
      deltas[updates["task_id"]] = 1
      deltas
    end

    def min(chart_dates)
      chart_dates.inject(nil) do |min, chart_date|
        date_min = chart_date[:values].values.min
        min.nil? ? date_min : [date_min, min].min
      end
    end

    def max(chart_dates)
      chart_dates.inject(nil) do |max, chart_date|
        date_max = chart_date[:values].values.max
        max.nil? ? date_max : [date_max, max].max
      end
    end

    def x_values(chart_dates, start_date)
      chart_dates.each do |chart_date|
        chart_date[:x] = (chart_date[:date] - start_date).to_f * 88 / (chart_dates.length - 1) + 10
      end
    end

    def y_values(chart_dates, min, max)
      chart_dates.each do |chart_date|
        y = chart_date[:y] = {}
        chart_date[:values].each do |key, value|
          y[key] = 90 - (value - min).to_f * 80 / (max - min)
        end
      end
    end
end
