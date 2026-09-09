require "test_helper"

class ProductRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_request = product_requests(:pepe_ps2)
  end

  test "a logged-in user with a phone can create a product request" do
    login(users(:maria))
    assert_difference("ProductRequest.count", 1) do
      post product_requests_path(product_id: products(:switch).id)
    end
    assert_redirected_to product_path(products(:switch))
  end

  test "a logged-in user without a phone cannot create a product request" do
    login(users(:sinfono))
    assert_no_difference("ProductRequest.count") do
      post product_requests_path(product_id: products(:switch).id)
    end
    assert_redirected_to product_path(products(:switch))
  end

  test "a guest cannot create a product request" do
    assert_no_difference("ProductRequest.count") do
      post product_requests_path(product_id: products(:switch).id)
    end
    assert_redirected_to new_session_path
  end

  test "does not allow a non-admin to view the requests index" do
    login(users(:maria))
    get product_requests_path
    assert_redirected_to products_path
  end

  test "allows the admin to view the requests index" do
    login
    get product_requests_path
    assert_response :success
  end

  test "does not allow a non-admin to mark a request as attended" do
    login(users(:maria))
    patch attend_product_request_path(@product_request)
    assert_redirected_to products_path
  end

  test "allows the admin to mark a request as attended" do
    login
    request = product_requests(:maria_switch)
    patch attend_product_request_path(request)
    assert request.reload.attended?
    assert_redirected_to product_requests_path
  end

  test "allows the admin to mark a request as not attended" do
    login
    patch unattend_product_request_path(@product_request)
    refute @product_request.reload.attended?
    assert_redirected_to product_requests_path
  end
end
