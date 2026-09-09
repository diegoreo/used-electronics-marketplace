require "test_helper"

class UserTest < ActiveSupport::TestCase
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
