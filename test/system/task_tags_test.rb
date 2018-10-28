require "application_system_test_case"

class TaskTagsTest < ApplicationSystemTestCase
  setup do
    @task_tag = task_tags(:one)
  end

  test "visiting the index" do
    visit task_tags_url
    assert_selector "h1", text: "Task Tags"
  end

  test "creating a Task tag" do
    visit task_tags_url
    click_on "New Task Tag"

    click_on "Create Task tag"

    assert_text "Task tag was successfully created"
    click_on "Back"
  end

  test "updating a Task tag" do
    visit task_tags_url
    click_on "Edit", match: :first

    click_on "Update Task tag"

    assert_text "Task tag was successfully updated"
    click_on "Back"
  end

  test "destroying a Task tag" do
    visit task_tags_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Task tag was successfully destroyed"
  end
end
