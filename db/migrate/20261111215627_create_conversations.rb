class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :admin_last_read_at
      t.datetime :last_message_at

      t.timestamps
    end
    add_index :conversations, [:product_id, :user_id], unique: true
  end
end
