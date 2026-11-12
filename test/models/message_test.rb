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
end
