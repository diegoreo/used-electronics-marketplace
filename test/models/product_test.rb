require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "featured? is false by default" do
    refute products(:ps2).featured?
  end

  test "feature! sets featured_at" do
    product = products(:ps2)
    product.feature!
    assert product.reload.featured?
  end

  test "unfeature! clears featured_at" do
    product = products(:switch)
    product.feature!
    product.unfeature!
    refute product.reload.featured?
  end

  test "featured orders by most recently featured first" do
    products(:ps2).update!(featured_at: 2.days.ago)
    products(:switch).update!(featured_at: 1.day.ago)

    assert_equal [products(:switch), products(:ps2)], Product.featured.to_a
  end

  test "featured only includes products with featured_at set" do
    products(:ps2).update!(featured_at: Time.current)
    refute_includes Product.featured, products(:air)
  end

  test "cover_photo is the first attached photo" do
    product = products(:ps2)
    product.photos.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.gif")), filename: "one.gif", content_type: "image/gif")
    product.photos.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.gif")), filename: "two.gif", content_type: "image/gif")

    assert_equal product.photos.first, product.cover_photo
  end
end
