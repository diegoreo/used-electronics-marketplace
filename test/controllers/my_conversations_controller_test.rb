require "test_helper"

class MyConversationsControllerTest < ActionDispatch::IntegrationTest
  test "a buyer only sees their own conversations, not other buyers'" do
    mine = Conversation.create!(product: products(:ps2), user: users(:maria))
    mine.add_message(user: users(:maria), content: "Hola")

    someone_elses = Conversation.create!(product: products(:air), user: users(:pepe))
    someone_elses.add_message(user: users(:pepe), content: "Hola")

    login(users(:maria))
    get my_conversations_path

    assert_includes response.body, products(:ps2).title
    refute_includes response.body, products(:air).title
  end

  test "shows an empty state message when the buyer has no conversations" do
    login(users(:maria))
    get my_conversations_path

    assert_select "p", text: I18n.t("my_conversations.index.empty")
  end

  test "does not allow an admin to view this page" do
    login(users(:paco))
    get my_conversations_path
    assert_redirected_to products_path
  end

  test "does not allow a guest to view this page" do
    get my_conversations_path
    assert_redirected_to new_session_path
  end
end
