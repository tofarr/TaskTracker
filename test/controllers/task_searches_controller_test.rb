require 'test_helper'

class TaskSearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_search = task_searches(:one)
  end

  test "should get index" do
    get task_searches_url
    assert_response :success
  end

  test "should get new" do
    get new_task_search_url
    assert_response :success
  end

  test "should create task_search" do
    assert_difference('TaskSearch.count') do
      post task_searches_url, params: { task_search: { query: @task_search.query } }
    end

    assert_redirected_to task_search_url(TaskSearch.last)
  end

  test "should show task_search" do
    get task_search_url(@task_search)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_search_url(@task_search)
    assert_response :success
  end

  test "should update task_search" do
    patch task_search_url(@task_search), params: { task_search: { query: @task_search.query } }
    assert_redirected_to task_search_url(@task_search)
  end

  test "should destroy task_search" do
    assert_difference('TaskSearch.count', -1) do
      delete task_search_url(@task_search)
    end

    assert_redirected_to task_searches_url
  end
end
