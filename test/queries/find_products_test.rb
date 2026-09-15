require "test_helper"

class FindProductsTest < ActiveSupport::TestCase
  [:newest, :expensive, :cheapest].each do |order_by|
    test "paginating with ties in the #{order_by} sort column does not duplicate or skip rows" do
      tied_time = 1.day.ago
      products = 5.times.map do
        Product.create!(title: "x", description: "y", price: 100, category: categories(:computers), user: users(:paco), created_at: tied_time)
      end
      product_ids = products.map(&:id)

      scoped = FindProducts.new.call(order_by: order_by).where(id: product_ids)
      page_1_ids = scoped.limit(3).offset(0).to_a.map(&:id)
      page_2_ids = scoped.limit(3).offset(3).to_a.map(&:id)

      assert_empty page_1_ids & page_2_ids
      assert_equal product_ids.sort, (page_1_ids + page_2_ids).sort
    end
  end
end
