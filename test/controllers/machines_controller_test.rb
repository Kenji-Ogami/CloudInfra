require "test_helper"

class MachinesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get machines_new_url
    assert_response :success
  end
end
