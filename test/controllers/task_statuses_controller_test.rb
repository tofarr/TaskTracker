require 'test_helper'

class TaskStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_status = task_statuses(:one)
  end

  test "should get index" do
    get task_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_task_status_url
    assert_response :success
  end

  test "should create task_status" do
    assert_difference('TaskStatus.count') do
      post task_statuses_url, params: { task_status: { description: @task_status.description, requires_action: @task_status.requires_action, title: @task_status.title } }
    end

    assert_redirected_to task_status_url(TaskStatus.last)
  end

  test "should show task_status" do
    get task_status_url(@task_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_status_url(@task_status)
    assert_response :success
  end

  test "should update task_status" do
    patch task_status_url(@task_status), params: { task_status: { description: @task_status.description, requires_action: @task_status.requires_action, title: @task_status.title } }
    assert_redirected_to task_status_url(@task_status)
  end

  test "should destroy task_status" do
    assert_difference('TaskStatus.count', -1) do
      delete task_status_url(@task_status)
    end

    assert_redirected_to task_statuses_url
  end
end
