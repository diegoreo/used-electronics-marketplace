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

  has_many_attached :photos
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  

  belongs_to :category
  belongs_to :user, default: -> { Current.user }

  has_many :product_requests, dependent: :destroy

  def cover_photo
    photos.first
  end

  def og_image
    cover_photo&.variant(resize_to_fill: [1200, 630])
  end

  def featured?
    featured_at.present?
  end

  def feature!
    update(featured_at: Time.current)
  end

  def unfeature!
    update(featured_at: nil)
  end

  def self.featured
    where.not(featured_at: nil).order(featured_at: :desc)
  end

  def broadcast
    broadcast_replace_to self, partial: "products/product_details", locals: { product: self}
  end

end
