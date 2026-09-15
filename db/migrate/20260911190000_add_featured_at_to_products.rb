class AddFeaturedAtToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :featured_at, :datetime
  end
end
