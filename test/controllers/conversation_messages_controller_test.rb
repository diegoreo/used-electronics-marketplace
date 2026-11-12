require "test_helper"

class ConversationMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    @conversation.add_message(user: users(:maria), content: "Hola, sigue disponible?")
  end

  test "allows the admin to reply" do
    login(users(:paco))

    assert_difference("Message.count", 1) do
      post conversation_messages_path(@conversation), params: { message: { content: "Si, disponible" } }
    end

    assert_equal users(:paco), @conversation.messages.last.user
    assert_redirected_to conversation_path(@conversation)
  end

  test "the reply author is always Current.user, ignoring any user_id in params" do
    login(users(:paco))
    post conversation_messages_path(@conversation), params: { message: { content: "Si", user_id: users(:pepe).id } }

    assert_equal users(:paco), @conversation.messages.last.user
  end

  test "does not allow a non-admin to reply" do
    login(users(:maria))

    assert_no_difference("Message.count") do
      post conversation_messages_path(@conversation), params: { message: { content: "Hola" } }
    end
    assert_redirected_to products_path
  end
end
