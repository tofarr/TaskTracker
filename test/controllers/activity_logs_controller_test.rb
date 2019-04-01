require 'test_helper'

class ActivityLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_log = activity_logs(:one)
  end

  test "should get index" do
    get activity_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_log_url
    assert_response :success
  end

  test "should create activity_log" do
    assert_difference('ActivityLog.count') do
      post activity_logs_url, params: { activity_log: {  } }
    end

    assert_redirected_to activity_log_url(ActivityLog.last)
  end

  test "should show activity_log" do
    get activity_log_url(@activity_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_log_url(@activity_log)
    assert_response :success
  end

  test "should update activity_log" do
    patch activity_log_url(@activity_log), params: { activity_log: {  } }
    assert_redirected_to activity_log_url(@activity_log)
  end

  test "should destroy activity_log" do
    assert_difference('ActivityLog.count', -1) do
      delete activity_log_url(@activity_log)
    end

    assert_redirected_to activity_logs_url
  end
end
