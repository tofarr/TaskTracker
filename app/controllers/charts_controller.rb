class ChartsController < ApplicationController

  include ChartsHelper
  helper_method :project
  helper_method :project_x
  helper_method :project_y

  def status_pie
    @task_search = params[:task_search_id] ? TaskSearch.viewable_searches(current_user).find(params[:task_search_id]) : TaskSearch.new
    @task_search.assign_attributes(TaskSearchesController.task_search_params(params))
    @task_search.user = current_user
    status_counts = @task_search.search(current_user).group(:status_id).count
    @num_statuses = status_counts.values.sum
    @task_statuses = TaskStatus.select("task_statuses.*, 0 as count").find(status_counts.keys).map do |status|
      status.assign_attributes(count: status_counts[status.id])
      status
    end
  end

  #burndown_line
    # we get a bunch of matching task ids...

    # grab events for each of these from the activitity_log by day model='task', id in ()

    # from these, we go through and find the status of each task...

    # if the activity log had more details we could find out what changed...



    #@task_search = params[:task_search_id] ? TaskSearch.viewable_searches(current_user).find(params[:task_search_id]) : TaskSearch.new
    #@task_search.assign_attributes(TaskSearchesController.task_search_params(params))
    #@task_search.user = current_user
  #end
end
