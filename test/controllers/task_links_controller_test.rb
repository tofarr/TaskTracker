require 'test_helper'

class TaskLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_link = task_links(:one)
  end

  test "should get index" do
    get task_links_url
    assert_response :success
  end

  test "should get new" do
    get new_task_link_url
    assert_response :success
  end

  test "should create task_link" do
    assert_difference('TaskLink.count') do
      post task_links_url, params: { task_link: {  } }
    end

    assert_redirected_to task_link_url(TaskLink.last)
  end

  test "should show task_link" do
    get task_link_url(@task_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_link_url(@task_link)
    assert_response :success
  end

  test "should update task_link" do
    patch task_link_url(@task_link), params: { task_link: {  } }
    assert_redirected_to task_link_url(@task_link)
  end

  test "should destroy task_link" do
    assert_difference('TaskLink.count', -1) do
      delete task_link_url(@task_link)
    end

    assert_redirected_to task_links_url
  end
end
