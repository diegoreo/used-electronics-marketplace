require "test_helper"
class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup 
    login
  end

  test "render a list of products" do
    get products_path

    assert_response :success
    assert_select ".product", 12
    assert_select ".category", 10
  end

  test "render a list of products filtered by category" do
    get products_path(category_id: categories(:computers).id)

    assert_response :success
    assert_select ".product", 5
  end
  test "render a list of products filtered by min_price and max_price" do
    get products_path(min_price: 2000, max_price: 5500)

    assert_response :success
    assert_select ".product", 6
    assert_select "h2", "Nintendo Switch"
  end

  test "search  a product by query_text" do
    get products_path(query_text: "Nintendo Switch")

    assert_response :success
    assert_select ".product", 1
    assert_select "h2", "Nintendo Switch"
  end

  test "sort products by expensive prices first " do
    get products_path(order_by: "expensive")

    assert_response :success
    assert_select ".product", 12
    assert_select ".products .product:first-child h2", "Seat Panda clásico"
  end

  test "sort products by cheapest prices first " do
    get products_path(order_by: "cheapest")

    assert_response :success
    assert_select ".product", 12
    assert_select ".products .product:first-child h2", "El hobbit"
  end

  test "render a detailed product page" do
    get product_path(products(:ps2))

    assert_response :success
    assert_select ".title", "play station 2"
    assert_select ".description", "funciona correctamente, sin cable de video"
    assert_select ".price", "900$"
    assert_select "meta[property='og:title'][content=?]", "play station 2"
    assert_select "meta[property='og:url'][content=?]", product_url(products(:ps2))
  end

  test "render a new product form" do
    get new_product_path
    assert_response :success
    assert_select "form"
    
  end
test "allow to create a new product" do
  post products_path, params: {
    product: {
      title: "Nintendo 64", 
      description: "le faltan los cables",
      price: 45,
      category_id: categories(:videogames).id
    }
  }
  assert_redirected_to products_path
  assert_equal flash[:notice], "Tu producto se ha creado correctamente"

end

test "does not allow to create a new product with empty fields" do
  post products_path, params: {
    product: {
      title: "", 
      description: "le faltan los cables",
      price: 45
    }
  }
  assert_response :unprocessable_entity
  
end

test "render an edit product form" do
  get edit_product_path(products(:ps2)) 
  assert_response :success
  assert_select "form"
  
end

test "allow to update a product" do
  patch product_path(products(:ps2)) , params: {
    product: {
      
      price: 45
    }
  }
  assert_redirected_to products_path
  assert_equal flash[:notice], "Tu producto se ha actualizado correctamente"

end

test "does not allow to update a product" do
  patch product_path(products(:ps2)), params: {
    product: {
      
      price: nil
    }
  }
  assert_response :unprocessable_entity

end

test "can delete product" do
  assert_difference("Product.count", -1) do
   delete product_path(products(:ps2))
  end
  assert_redirected_to products_path
  assert_equal flash[:notice], "Tu producto se ha eliminado correctamente"
end

test "does not allow a non-admin to view the new product form" do
  login(users(:maria))
  get new_product_path
  assert_redirected_to products_path
end

test "does not allow a non-admin to create a product" do
  login(users(:maria))
  assert_no_difference("Product.count") do
    post products_path, params: {
      product: {
        title: "Producto no autorizado",
        description: "no deberia crearse",
        price: 100,
        category_id: categories(:videogames).id
      }
    }
  end
  assert_redirected_to products_path
end

test "does not allow a non-admin to view the edit product form" do
  login(users(:maria))
  get edit_product_path(products(:ps2))
  assert_redirected_to products_path
end

test "does not allow a non-admin to update a product" do
  login(users(:maria))
  patch product_path(products(:ps2)), params: { product: { price: 1 } }
  assert_redirected_to products_path
  assert_not_equal 1, products(:ps2).reload.price
end

test "does not allow a non-admin to delete a product" do
  login(users(:maria))
  assert_no_difference("Product.count") do
    delete product_path(products(:ps2))
  end
  assert_redirected_to products_path
end

test "does not show the favorite heart to a guest" do
  delete session_path(users(:paco).id)
  get product_path(products(:ps2))
  assert_select "#favorite", count: 0
end

test "allows the admin to feature a product" do
  patch feature_product_path(products(:ps2))
  assert products(:ps2).reload.featured?
  assert_redirected_to product_path(products(:ps2))
end

test "allows the admin to unfeature a product" do
  products(:ps2).update!(featured_at: Time.current)
  patch unfeature_product_path(products(:ps2))
  refute products(:ps2).reload.featured?
end

test "does not allow a non-admin to feature a product" do
  login(users(:maria))
  patch feature_product_path(products(:ps2))
  refute products(:ps2).reload.featured?
  assert_redirected_to products_path
end

test "does not allow a non-admin to unfeature a product" do
  login(users(:maria))
  products(:ps2).update!(featured_at: Time.current)
  patch unfeature_product_path(products(:ps2))
  assert products(:ps2).reload.featured?
  assert_redirected_to products_path
end

test "shows the featured section when there are featured products" do
  products(:ps2).update!(featured_at: Time.current)
  get products_path
  assert_select "#featured-products"
end

test "hides the featured section when there are no featured products" do
  get products_path
  assert_select "#featured-products", count: 0
end

test "adding a new photo on update does not remove existing ones" do
  product = products(:ps2)
  product.photos.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.gif")), filename: "one.gif", content_type: "image/gif")
  product.photos.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.gif")), filename: "two.gif", content_type: "image/gif")
  assert_equal 2, product.photos.count

  patch product_path(product), params: {
    product: { photos: [fixture_file_upload("sample.gif", "image/gif")] }
  }

  assert_equal 3, product.reload.photos.count
end

test "allows the admin to delete an individual photo" do
  product = products(:ps2)
  product.photos.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.gif")), filename: "one.gif", content_type: "image/gif")
  photo = product.photos.first

  assert_difference("product.photos.count", -1) do
    delete product_photo_path(product, photo)
  end
  assert_redirected_to edit_product_path(product)
end

test "does not allow a non-admin to delete a photo" do
  product = products(:ps2)
  product.photos.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.gif")), filename: "one.gif", content_type: "image/gif")
  photo = product.photos.first
  login(users(:maria))

  assert_no_difference("product.photos.count") do
    delete product_photo_path(product, photo)
  end
  assert_redirected_to products_path
end

test "a logged-in buyer sees the chat section on the product page" do
  login(users(:maria))
  get product_path(products(:ps2))
  assert_select "h2", text: I18n.t("products.show.chat_title")
end

test "the admin does not see the chat section on the product page" do
  get product_path(products(:ps2))
  refute_includes response.body, I18n.t("products.show.chat_title")
end

test "a guest sees a prompt to log in instead of the chat section" do
  delete session_path(users(:paco).id)
  get product_path(products(:ps2))
  assert_select "a", text: I18n.t("products.show.login_to_chat")
end

test "the header shows an unread badge for the admin when there is an unread conversation" do
  conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
  conversation.add_message(user: users(:maria), content: "Hola")

  get products_path

  assert_select "a[href='#{conversations_path}'] span", text: "1"
end

test "the header shows no badge once the conversation has been read" do
  conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
  conversation.add_message(user: users(:maria), content: "Hola")
  conversation.mark_as_read!

  get products_path

  assert_select "a[href='#{conversations_path}'] span", count: 0
end

test "the product chat section wires up the mark-as-read controller with the right URL" do
  login(users(:maria))
  get product_path(products(:ps2))

  assert_select "[data-controller='scroll-to-chat mark-as-read']"
  assert_includes response.body, read_product_messages_path(products(:ps2))
end

test "the header subscribes the admin only to the admin_inbox stream" do
  login(users(:paco))
  get products_path

  assert_includes response.body, Turbo::StreamsChannel.signed_stream_name(:admin_inbox)
  refute_includes response.body, Turbo::StreamsChannel.signed_stream_name([ :buyer_inbox, users(:paco) ])
end

test "the header subscribes a buyer only to their own buyer_inbox stream, never another buyer's" do
  login(users(:maria))
  get products_path

  refute_includes response.body, Turbo::StreamsChannel.signed_stream_name(:admin_inbox)
  assert_includes response.body, Turbo::StreamsChannel.signed_stream_name([ :buyer_inbox, users(:maria) ])
  refute_includes response.body, Turbo::StreamsChannel.signed_stream_name([ :buyer_inbox, users(:pepe) ])
end

test "a guest is not subscribed to any inbox stream" do
  delete session_path(users(:paco).id)
  get products_path

  refute_includes response.body, "turbo-cable-stream-source"
end

end