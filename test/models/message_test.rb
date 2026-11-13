require "test_helper"
require "turbo/broadcastable/test_helper"

class MessageTest < ActiveSupport::TestCase
  include Turbo::Broadcastable::TestHelper

  test "broadcast_to_conversation appends to the conversation's stream, targeting #messages" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    message = conversation.messages.create!(user: users(:maria), content: "Hola, sigue disponible?")

    turbo_streams = capture_turbo_stream_broadcasts(conversation) do
      message.broadcast_to_conversation
    end

    assert_equal 1, turbo_streams.size
    assert_equal "append", turbo_streams.first["action"]
    assert_equal "messages", turbo_streams.first["target"]
  end

  test "notify_recipient broadcasts the admin badge when the buyer writes" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    message = conversation.messages.create!(user: users(:maria), content: "Hola")

    turbo_streams = capture_turbo_stream_broadcasts(:admin_inbox) { message.notify_recipient }

    assert_equal 1, turbo_streams.size
    assert_equal "replace", turbo_streams.first["action"]
  end

  test "notify_recipient broadcasts the buyer's own badge when the admin replies" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    message = conversation.messages.create!(user: users(:paco), content: "Si, disponible")

    turbo_streams = capture_turbo_stream_broadcasts([ :buyer_inbox, users(:maria) ]) { message.notify_recipient }

    assert_equal 1, turbo_streams.size
  end

  test "notify_recipient never broadcasts to a different buyer's stream" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    message = conversation.messages.create!(user: users(:paco), content: "Si, disponible")

    turbo_streams = capture_turbo_stream_broadcasts([ :buyer_inbox, users(:pepe) ]) { message.notify_recipient }

    assert_equal 0, turbo_streams.size
  end
end
