require 'test_helper'

class TaskTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_tag = task_tags(:one)
  end

  test "should get index" do
    get task_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_task_tag_url
    assert_response :success
  end

  test "should create task_tag" do
    assert_difference('TaskTag.count') do
      post task_tags_url, params: { task_tag: {  } }
    end

    assert_redirected_to task_tag_url(TaskTag.last)
  end

  test "should show task_tag" do
    get task_tag_url(@task_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_tag_url(@task_tag)
    assert_response :success
  end

  test "should update task_tag" do
    patch task_tag_url(@task_tag), params: { task_tag: {  } }
    assert_redirected_to task_tag_url(@task_tag)
  end

  test "should destroy task_tag" do
    assert_difference('TaskTag.count', -1) do
      delete task_tag_url(@task_tag)
    end

    assert_redirected_to task_tags_url
  end
end
