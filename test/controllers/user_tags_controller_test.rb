require 'test_helper'

class UserTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_tag = user_tags(:one)
  end

  test "should get index" do
    get user_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_user_tag_url
    assert_response :success
  end

  test "should create user_tag" do
    assert_difference('UserTag.count') do
      post user_tags_url, params: { user_tag: { description: @user_tag.description, title: @user_tag.title } }
    end

    assert_redirected_to user_tag_url(UserTag.last)
  end

  test "should show user_tag" do
    get user_tag_url(@user_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_tag_url(@user_tag)
    assert_response :success
  end

  test "should update user_tag" do
    patch user_tag_url(@user_tag), params: { user_tag: { description: @user_tag.description, title: @user_tag.title } }
    assert_redirected_to user_tag_url(@user_tag)
  end

  test "should destroy user_tag" do
    assert_difference('UserTag.count', -1) do
      delete user_tag_url(@user_tag)
    end

    assert_redirected_to user_tags_url
  end
end
