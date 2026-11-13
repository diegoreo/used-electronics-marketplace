class AddBuyerLastReadAtToConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :buyer_last_read_at, :datetime
  end
end
