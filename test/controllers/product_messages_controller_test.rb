require "test_helper"
require "turbo/broadcastable/test_helper"

class ProductMessagesControllerTest < ActionDispatch::IntegrationTest
  include Turbo::Broadcastable::TestHelper

  setup { login(users(:maria)) }

  test "allows a logged-in non-admin to send a message, creating the conversation on first use" do
    assert_difference [ "Conversation.count", "Message.count" ], 1 do
      post product_messages_path(products(:ps2)), params: { message: { content: "Hola, sigue disponible?" } }
    end

    conversation = Conversation.find_by(product: products(:ps2), user: users(:maria))
    assert_equal "Hola, sigue disponible?", conversation.messages.last.content
    assert_redirected_to product_path(products(:ps2), scroll_to_chat: true)
  end

  test "reuses the existing conversation for the same buyer and product" do
    post product_messages_path(products(:ps2)), params: { message: { content: "Primero" } }

    assert_no_difference("Conversation.count") do
      post product_messages_path(products(:ps2)), params: { message: { content: "Segundo" } }
    end
  end

  test "the message author is always Current.user, ignoring any user_id in params" do
    post product_messages_path(products(:ps2)), params: { message: { content: "Hola", user_id: users(:pepe).id } }

    message = Conversation.find_by(product: products(:ps2), user: users(:maria)).messages.last
    assert_equal users(:maria), message.user
  end

  test "does not allow an admin to send a message from this endpoint" do
    login(users(:paco))

    assert_no_difference("Message.count") do
      post product_messages_path(products(:ps2)), params: { message: { content: "Hola" } }
    end
    assert_redirected_to products_path
  end

  test "does not create a message when content is blank" do
    assert_no_difference("Message.count") do
      post product_messages_path(products(:ps2)), params: { message: { content: "" } }
    end
  end

  test "does not create a phantom conversation when the first message is invalid" do
    assert_no_difference("Conversation.count") do
      post product_messages_path(products(:ps2)), params: { message: { content: "" } }
    end
  end

  test "redirects with scroll_to_chat even when the message is invalid" do
    post product_messages_path(products(:ps2)), params: { message: { content: "" } }
    assert_redirected_to product_path(products(:ps2), scroll_to_chat: true)
  end

  test "creating a message notifies the admin badge stream" do
    turbo_streams = capture_turbo_stream_broadcasts(:admin_inbox) do
      post product_messages_path(products(:ps2)), params: { message: { content: "Hola" } }
    end

    assert_equal 1, turbo_streams.size
  end

  test "a guest cannot post a message, and no conversation is created" do
    delete session_path(users(:maria).id)

    assert_no_difference("Conversation.count") do
      post product_messages_path(products(:ps2)), params: { message: { content: "Hola" } }
    end
    assert_redirected_to new_session_path
  end

  test "the buyer can mark their own conversation as read" do
    conversation = Conversation.for(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:paco), content: "Si, disponible")

    patch read_product_messages_path(products(:ps2))

    assert_response :no_content
    refute conversation.reload.unread_by_buyer?
  end

  test "marking as read is a no-op when the buyer has no conversation yet for this product" do
    patch read_product_messages_path(products(:ps2))
    assert_response :no_content
  end

  test "a guest cannot mark a conversation as read" do
    delete session_path(users(:maria).id)
    patch read_product_messages_path(products(:ps2))
    assert_redirected_to new_session_path
  end

  test "an admin cannot use the buyer's read endpoint" do
    login(users(:paco))
    patch read_product_messages_path(products(:ps2))
    assert_redirected_to products_path
  end
end
