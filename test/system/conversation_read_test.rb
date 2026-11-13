require "application_system_test_case"

class ConversationReadTest < ApplicationSystemTestCase
  test "opening a conversation marks it as read, via the JS-driven mark-as-read request" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:maria), content: "Hola, sigue disponible?")

    login_as users(:paco)
    visit conversations_url
    assert_selector "a.font-bold"

    click_link products(:ps2).title
    assert_current_path conversation_path(conversation)

    visit conversations_url
    assert_no_selector "a.font-bold"
  end

  private

  def login_as(user)
    visit new_session_path
    fill_in "login", with: user.email
    fill_in "password", with: "testme"
    find("input[type=submit]").click
    assert_text "Bienvenido!"
  end
end
