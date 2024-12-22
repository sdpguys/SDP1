require "test_helper"

class Admin::NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_notifications_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_notifications_create_url
    assert_response :success
  end
end
