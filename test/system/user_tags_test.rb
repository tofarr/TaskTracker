require "application_system_test_case"

class UserTagsTest < ApplicationSystemTestCase
  setup do
    @user_tag = user_tags(:one)
  end

  test "visiting the index" do
    visit user_tags_url
    assert_selector "h1", text: "User Tags"
  end

  test "creating a User tag" do
    visit user_tags_url
    click_on "New User Tag"

    fill_in "Description", with: @user_tag.description
    fill_in "Title", with: @user_tag.title
    click_on "Create User tag"

    assert_text "User tag was successfully created"
    click_on "Back"
  end

  test "updating a User tag" do
    visit user_tags_url
    click_on "Edit", match: :first

    fill_in "Description", with: @user_tag.description
    fill_in "Title", with: @user_tag.title
    click_on "Update User tag"

    assert_text "User tag was successfully updated"
    click_on "Back"
  end

  test "destroying a User tag" do
    visit user_tags_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User tag was successfully destroyed"
  end
end
