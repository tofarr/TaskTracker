require "application_system_test_case"

class TaskStatusesTest < ApplicationSystemTestCase
  setup do
    @task_status = task_statuses(:one)
  end

  test "visiting the index" do
    visit task_statuses_url
    assert_selector "h1", text: "Task Statuses"
  end

  test "creating a Task status" do
    visit task_statuses_url
    click_on "New Task Status"

    fill_in "Description", with: @task_status.description
    fill_in "Requires Action", with: @task_status.requires_action
    fill_in "Title", with: @task_status.title
    click_on "Create Task status"

    assert_text "Task status was successfully created"
    click_on "Back"
  end

  test "updating a Task status" do
    visit task_statuses_url
    click_on "Edit", match: :first

    fill_in "Description", with: @task_status.description
    fill_in "Requires Action", with: @task_status.requires_action
    fill_in "Title", with: @task_status.title
    click_on "Update Task status"

    assert_text "Task status was successfully updated"
    click_on "Back"
  end

  test "destroying a Task status" do
    visit task_statuses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Task status was successfully destroyed"
  end
end
