require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get not found" do
    get "/test_404"
    assert_response :not_found
  end

  test "should get internal server error" do
    get "/test_500"
    assert_response :internal_server_error
  end
end
