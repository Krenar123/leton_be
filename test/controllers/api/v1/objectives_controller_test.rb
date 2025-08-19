require "test_helper"

class Api::V1::ObjectivesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_objectives_show_url
    assert_response :success
  end
end
