require "test_helper"

class ProductsHelperTest < ActionView::TestCase
  test "uses the default image when the product has no photo" do
    assert_match "imagen", product_og_image_url(products(:ps2))
  end
end
