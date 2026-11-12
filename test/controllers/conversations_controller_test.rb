require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  setup do
    @conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    @conversation.add_message(user: users(:maria), content: "Hola, sigue disponible?")
  end

  test "allows the admin to view the inbox" do
    login(users(:paco))
    get conversations_path
    assert_response :success
  end

  test "allows the admin to open a conversation and marks it as read" do
    login(users(:paco))
    assert @conversation.unread_by_admin?

    get conversation_path(@conversation)

    assert_response :success
    refute @conversation.reload.unread_by_admin?
  end

  test "does not allow a non-admin to view the inbox" do
    login(users(:maria))
    get conversations_path
    assert_redirected_to products_path
  end

  test "does not allow a non-admin to open a conversation" do
    login(users(:maria))
    get conversation_path(@conversation)
    assert_redirected_to products_path
  end

  test "orders conversations by most recent message first" do
    travel(1.minute) do
      newer = Conversation.create!(product: products(:air), user: users(:pepe))
      newer.add_message(user: users(:pepe), content: "Hola")
    end

    login(users(:paco))
    get conversations_path

    newer_index = response.body.index(products(:air).title)
    older_index = response.body.index(products(:ps2).title)

    assert newer_index < older_index
  end

  test "marks unread conversations visually in the inbox" do
    login(users(:paco))
    get conversations_path

    assert_select "a.font-bold", count: 1
  end

  test "does not mark read conversations as unread in the inbox" do
    @conversation.mark_as_read!

    login(users(:paco))
    get conversations_path

    assert_select "a.font-bold", count: 0
  end
end
