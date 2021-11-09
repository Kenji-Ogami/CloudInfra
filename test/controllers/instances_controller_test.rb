require "test_helper"

class InstancesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get instances_new_url
    assert_response :success
  end
end
