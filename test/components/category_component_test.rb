# frozen_string_literal: true

require "test_helper"

class CategoryComponentTest < ViewComponent::TestCase
  test "should render an empty category" do
     assert_equal(
       %(<a class=\"category whitespace-nowrap px-4 py-2 rounded-full text-sm font-semibold border transition-colors border-brand-gold text-brand-gold bg-brand-gold/10\" href=\"/\">Todos</a>),
       render_inline(CategoryComponent.new).to_html
     )
  end

  test "should render a category" do
    category = Category.last
    assert_equal(
      %(<a class=\"category whitespace-nowrap px-4 py-2 rounded-full text-sm font-semibold border transition-colors border-brand-border text-brand-text-secondary bg-brand-surface hover:border-brand-gold hover:text-brand-gold\" href=\"/?category_id=#{category.id}\">#{category.name}</a>),
      render_inline(CategoryComponent.new(category: category)).to_html
    )
 end

end
