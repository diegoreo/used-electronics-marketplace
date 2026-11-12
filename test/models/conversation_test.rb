require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test "add_message creates a message and updates last_message_at" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    message = conversation.add_message(user: users(:maria), content: "Hola, sigue disponible?")

    assert message.persisted?
    assert_equal message.created_at.to_i, conversation.reload.last_message_at.to_i
  end

  test "add_message does not persist a blank message, and does not touch last_message_at" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    message = conversation.add_message(user: users(:maria), content: "")

    refute message.persisted?
    assert_nil conversation.reload.last_message_at
  end

  test "a buyer can only have one conversation per product" do
    Conversation.create!(product: products(:ps2), user: users(:maria))
    duplicate = Conversation.new(product: products(:ps2), user: users(:maria))

    refute duplicate.valid?
  end

  test ".for returns the existing conversation instead of raising" do
    existing = Conversation.create!(product: products(:ps2), user: users(:maria))

    assert_equal existing, Conversation.for(product: products(:ps2), user: users(:maria))
  end

  test ".for creates a new conversation when none exists" do
    assert_difference "Conversation.count", 1 do
      Conversation.for(product: products(:ps2), user: users(:maria))
    end
  end

  test "unread_by_admin? is true after the buyer sends a message" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:maria), content: "Hola")

    assert conversation.unread_by_admin?
  end

  test "unread_by_admin? is false right after the admin replies, once the admin has read the conversation first" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:maria), content: "Hola")

    travel(1.minute) do
      conversation.mark_as_read!
      conversation.add_message(user: users(:paco), content: "Si, disponible")
    end

    refute conversation.unread_by_admin?
  end

  test "replying without first reading does not mark the conversation as read" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:maria), content: "Hola")

    travel(1.minute) { conversation.add_message(user: users(:paco), content: "Si, disponible") }

    assert conversation.unread_by_admin?
  end

  test "unread_by_admin? is true again once the buyer writes after being marked read" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:maria), content: "Hola")
    travel(1.minute) { conversation.mark_as_read! }

    travel(2.minutes) { conversation.add_message(user: users(:maria), content: "Sigue disponible?") }

    assert conversation.unread_by_admin?
  end

  test "unread_by_admin_count counts each unread conversation once, even with multiple buyer messages" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:maria), content: "Hola")
    conversation.add_message(user: users(:maria), content: "Sigue disponible?")

    assert_equal 1, Conversation.unread_by_admin_count
  end

  test "unread_by_admin_count excludes conversations the admin has already read" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    conversation.add_message(user: users(:maria), content: "Hola")
    conversation.mark_as_read!

    assert_equal 0, Conversation.unread_by_admin_count
  end

  test "unread_by_admin_count only counts conversations with an unread buyer message" do
    read_conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    read_conversation.add_message(user: users(:maria), content: "Hola")
    read_conversation.mark_as_read!

    unread_conversation = Conversation.create!(product: products(:air), user: users(:pepe))
    unread_conversation.add_message(user: users(:pepe), content: "Hola")

    assert_equal 1, Conversation.unread_by_admin_count
  end
end
