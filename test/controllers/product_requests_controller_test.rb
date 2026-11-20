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

  test "the index defaults to the \"all\" filter and shows every request" do
    login
    get product_requests_path
    assert_includes response.body, products(:switch).title
    assert_includes response.body, products(:ps2).title
  end

  test "the index with filter=pending only shows unattended requests" do
    login
    get product_requests_path(filter: "pending")
    assert_includes response.body, products(:switch).title
    refute_includes response.body, products(:ps2).title
  end

  test "the index with filter=attended only shows attended requests" do
    login
    get product_requests_path(filter: "attended")
    refute_includes response.body, products(:switch).title
    assert_includes response.body, products(:ps2).title
  end

  test "an unknown filter value falls back to \"all\" instead of raising" do
    login
    get product_requests_path(filter: "bogus")
    assert_response :success
    assert_includes response.body, products(:switch).title
    assert_includes response.body, products(:ps2).title
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

  test "marking a request as attended preserves the current filter in the redirect" do
    login
    request = product_requests(:maria_switch)
    patch attend_product_request_path(request, filter: "pending")
    assert_redirected_to product_requests_path(filter: "pending")
  end

  test "marking a request as attended via a turbo stream request updates the list and every badge copy, with no redirect" do
    login
    request = product_requests(:maria_switch)
    patch attend_product_request_path(request, filter: "pending"), as: :turbo_stream
    assert_response :success
    assert_equal Mime[:turbo_stream], response.media_type
    assert_includes response.body, %(target="product_requests_list")
    assert_includes response.body, %(targets=".product-requests-badge")
  end

  test "marking a request as attended via turbo stream removes it from the pending-filtered list and updates the badge" do
    login
    request = product_requests(:maria_switch)
    patch attend_product_request_path(request, filter: "pending"), as: :turbo_stream
    assert_response :success
    refute_includes response.body, products(:switch).title
    assert_includes response.body, I18n.t("product_requests.list.empty_pending")
  end

  test "marking a request as attended via turbo stream also replaces the flash with the confirmation notice" do
    login
    request = product_requests(:maria_switch)
    patch attend_product_request_path(request), as: :turbo_stream
    assert_response :success
    assert_includes response.body, %(target="flash")
    assert_includes response.body, I18n.t("product_requests.attend.attended")
  end

  test "marking a request as not attended via turbo stream also replaces the flash with the confirmation notice" do
    login
    patch unattend_product_request_path(@product_request), as: :turbo_stream
    assert_response :success
    assert_includes response.body, %(target="flash")
    assert_includes response.body, I18n.t("product_requests.unattend.unattended")
  end

  test "the badge carries the hidden class when there are no pending requests" do
    ProductRequest.update_all(attended_at: Time.current)
    login
    get products_path
    assert_select ".product-requests-badge.hidden", count: 2, text: "0"
  end

  test "a non-admin cannot mark a request as attended via turbo stream either" do
    request = product_requests(:maria_switch)
    login(users(:maria))
    patch attend_product_request_path(request), as: :turbo_stream
    assert_redirected_to products_path
    refute request.reload.attended?
  end

  test "the badge renders once for the desktop nav and once for the mobile menu, both with the same class" do
    login
    get products_path
    assert_select ".product-requests-badge", count: 2, text: ProductRequest.pending_count.to_s
  end

  test "a non-admin never receives the pending-requests badge markup" do
    login(users(:maria))
    get products_path
    refute_includes response.body, "product-requests-badge"
  end

  test "a guest never receives the pending-requests badge markup" do
    get products_path
    refute_includes response.body, "product-requests-badge"
  end
end
