require "application_system_test_case"

class TaskSearchesTest < ApplicationSystemTestCase
  setup do
    @task_search = task_searches(:one)
  end

  test "visiting the index" do
    visit task_searches_url
    assert_selector "h1", text: "Task Searches"
  end

  test "creating a Task search" do
    visit task_searches_url
    click_on "New Task Search"

    fill_in "Query", with: @task_search.query
    click_on "Create Task search"

    assert_text "Task search was successfully created"
    click_on "Back"
  end

  test "updating a Task search" do
    visit task_searches_url
    click_on "Edit", match: :first

    fill_in "Query", with: @task_search.query
    click_on "Update Task search"

    assert_text "Task search was successfully updated"
    click_on "Back"
  end

  test "destroying a Task search" do
    visit task_searches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Task search was successfully destroyed"
  end
end
