require "application_system_test_case"

class TaskLinksTest < ApplicationSystemTestCase
  setup do
    @task_link = task_links(:one)
  end

  test "visiting the index" do
    visit task_links_url
    assert_selector "h1", text: "Task Links"
  end

  test "creating a Task link" do
    visit task_links_url
    click_on "New Task Link"

    click_on "Create Task link"

    assert_text "Task link was successfully created"
    click_on "Back"
  end

  test "updating a Task link" do
    visit task_links_url
    click_on "Edit", match: :first

    click_on "Update Task link"

    assert_text "Task link was successfully updated"
    click_on "Back"
  end

  test "destroying a Task link" do
    visit task_links_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Task link was successfully destroyed"
  end
end
