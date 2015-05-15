require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get all_days" do
    get :all_days
    assert_response :success
  end

  test "should get today" do
    get :today
    assert_response :success
  end

end
