require "test_helper"

class FavouritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:member1)
    # start_new_session_for @user
    post session_url, params: { email_address: @user.email_address, password: "P4ssw0rd!" }
  end

  test "should get index" do
    get favourites_url
    assert_response :success
  end
end
