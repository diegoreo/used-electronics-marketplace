class Conversation < ApplicationRecord
  belongs_to :product
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :user_id, uniqueness: { scope: :product_id }

  def self.for(product:, user:)
    find_by(product: product, user: user) ||
      transaction(requires_new: true) { create!(product: product, user: user) }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    find_by!(product: product, user: user)
  end

  def self.unread_by_admin_count
    joins(:messages)
      .where("messages.user_id = conversations.user_id")
      .where("conversations.admin_last_read_at IS NULL OR messages.created_at > conversations.admin_last_read_at")
      .distinct
      .count
  end

  def add_message(user:, content:)
    message = messages.build(user: user, content: content)
    transaction { update!(last_message_at: message.created_at) if message.save }
    message
  end

  def mark_as_read!
    update!(admin_last_read_at: Time.current)
  end

  def unread_by_admin?
    latest_buyer_message_at = messages.where(user_id: user_id).maximum(:created_at)
    return false if latest_buyer_message_at.nil?

    admin_last_read_at.nil? || latest_buyer_message_at > admin_last_read_at
  end
end
