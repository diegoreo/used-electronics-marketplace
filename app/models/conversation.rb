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

  def self.unread_by_buyer_count(user)
    where(user: user)
      .joins(:messages)
      .where("messages.user_id != conversations.user_id")
      .where("conversations.buyer_last_read_at IS NULL OR messages.created_at > conversations.buyer_last_read_at")
      .distinct
      .count
  end

  def self.broadcast_admin_badge
    Turbo::StreamsChannel.broadcast_replace_to(
      :admin_inbox, targets: ".admin-inbox-badge-link",
      partial: "shared/admin_inbox_badge", locals: { count: unread_by_admin_count }
    )
  end

  def self.broadcast_buyer_badge(user)
    Turbo::StreamsChannel.broadcast_replace_to(
      [ :buyer_inbox, user ], targets: ".buyer-inbox-badge-link",
      partial: "shared/buyer_inbox_badge", locals: { count: unread_by_buyer_count(user) }
    )
  end

  def add_message(user:, content:)
    message = messages.build(user: user, content: content)
    transaction { update!(last_message_at: message.created_at) if message.save }
    message
  end

  def mark_as_read!
    update!(admin_last_read_at: Time.current)
    self.class.broadcast_admin_badge
  end

  def mark_as_read_by_buyer!
    update!(buyer_last_read_at: Time.current)
    self.class.broadcast_buyer_badge(user)
  end

  def unread_by_admin?
    latest_buyer_message_at = messages.where(user_id: user_id).maximum(:created_at)
    return false if latest_buyer_message_at.nil?

    admin_last_read_at.nil? || latest_buyer_message_at > admin_last_read_at
  end

  def unread_by_buyer?
    latest_admin_message_at = messages.where.not(user_id: user_id).maximum(:created_at)
    return false if latest_admin_message_at.nil?

    buyer_last_read_at.nil? || latest_admin_message_at > buyer_last_read_at
  end
end
