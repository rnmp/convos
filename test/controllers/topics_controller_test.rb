require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  setup do
    @topic = topics(:one)
  end

  test "should show topic" do
    get :show, id: @topic
    assert_response :success
  end
end
