require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post registrations_url, params: {
        user: {
          email_address: "new_user@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_url # Oder die Ziel-URL nach der Registrierung
  end
end
