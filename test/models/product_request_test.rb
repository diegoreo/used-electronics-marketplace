require "test_helper"

class ProductRequestTest < ActiveSupport::TestCase
  test "attended? is false by default" do
    refute product_requests(:maria_switch).attended?
  end

  test "attended? is true once attended_at is set" do
    assert product_requests(:pepe_ps2).attended?
  end

  test "attend! sets attended_at" do
    product_request = product_requests(:maria_switch)
    product_request.attend!
    assert product_request.reload.attended?
  end

  test "unattend! clears attended_at" do
    product_request = product_requests(:pepe_ps2)
    product_request.unattend!
    refute product_request.reload.attended?
  end

  test ".pending_count only counts requests without attended_at" do
    assert_equal 1, ProductRequest.pending_count
  end

  test ".for_filter(\"pending\") only returns unattended requests" do
    assert_equal [ product_requests(:maria_switch) ], ProductRequest.for_filter("pending").to_a
  end

  test ".for_filter(\"attended\") only returns attended requests" do
    assert_equal [ product_requests(:pepe_ps2) ], ProductRequest.for_filter("attended").to_a
  end

  test ".for_filter(\"all\") returns every request, pending ones first" do
    assert_equal [ product_requests(:maria_switch), product_requests(:pepe_ps2) ], ProductRequest.for_filter("all").to_a
  end
end
