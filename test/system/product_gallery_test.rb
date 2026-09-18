require "application_system_test_case"

class ProductGalleryTest < ApplicationSystemTestCase
  test "clicking the product photo opens a lightbox with the full image, and Escape closes it" do
    product = products(:ps2)
    product.photos.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.gif")), filename: "one.gif", content_type: "image/gif")

    visit product_path(product)
    find("[data-gallery-target='slide']").click

    assert_selector "[data-gallery-target='lightbox']:not(.hidden)"

    page.driver.browser.action.send_keys(:escape).perform

    assert_selector "[data-gallery-target='lightbox'].hidden", visible: :all
  end
end
