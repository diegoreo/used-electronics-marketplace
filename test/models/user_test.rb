require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "destroying a user also destroys their conversations and messages" do
    conversation = Conversation.create!(product: products(:ps2), user: users(:maria))
    message = conversation.add_message(user: users(:maria), content: "Hola")

    users(:maria).destroy!

    refute Conversation.exists?(conversation.id)
    refute Message.exists?(message.id)
  end

  test "requires a phone number" do
    user = User.new(email: "nuevo@vendelo.com", username: "nuevo1", password: "testme")
    refute user.valid?
    assert user.errors[:phone].any?
  end

  test "is valid with a phone number" do
    user = User.new(email: "nuevo@vendelo.com", username: "nuevo1", password: "testme", phone: "555-0101")
    assert user.valid?
  end
end
