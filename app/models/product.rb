class Product < ApplicationRecord
  include PgSearch::Model
  include Favoritable
  pg_search_scope :search_full_text, against: {
    title: 'A',
    description: 'B'
  }

  ORDER_BY = {
    newest: "created_at DESC",
    expensive: "price DESC",
    cheapest: "price ASC"
  }

  has_one_attached :photo
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  

  belongs_to :category
  belongs_to :user, default: -> { Current.user }

  has_many :product_requests, dependent: :destroy

  def og_image
    photo.variant(resize_to_fill: [1200, 630]) if photo.attached?
  end

  def broadcast
    broadcast_replace_to self, partial: "products/product_details", locals: { product: self}
  end

end
