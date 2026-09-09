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
end
