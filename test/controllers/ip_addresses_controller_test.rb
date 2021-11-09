require "test_helper"

class IpAddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ip_addresses_new_url
    assert_response :success
  end
end
