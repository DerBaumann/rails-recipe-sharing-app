require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:member1)
    # start_new_session_for @user
    post session_url, params: { email_address: @user.email_address, password: "P4ssw0rd!" }
  end

  test "should get show" do
    get profile_url
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url
    assert_response :success
  end
end
