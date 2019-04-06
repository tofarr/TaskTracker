require "application_system_test_case"

class AuthTokensTest < ApplicationSystemTestCase
  setup do
    @auth_token = auth_tokens(:one)
  end

  test "visiting the index" do
    visit auth_tokens_url
    assert_selector "h1", text: "Auth Tokens"
  end

  test "creating a Auth token" do
    visit auth_tokens_url
    click_on "New Auth Token"

    click_on "Create Auth token"

    assert_text "Auth token was successfully created"
    click_on "Back"
  end

  test "updating a Auth token" do
    visit auth_tokens_url
    click_on "Edit", match: :first

    click_on "Update Auth token"

    assert_text "Auth token was successfully updated"
    click_on "Back"
  end

  test "destroying a Auth token" do
    visit auth_tokens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Auth token was successfully destroyed"
  end
end
