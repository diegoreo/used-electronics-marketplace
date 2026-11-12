class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :content, presence: true, length: { maximum: 2000 }

  def broadcast_to_conversation
    broadcast_append_to conversation, target: "messages", partial: "messages/message", locals: { message: self }
  end
end
