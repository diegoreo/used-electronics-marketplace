class ProductRequest < ApplicationRecord
  belongs_to :user
  belongs_to :product

  FILTERS = %w[all pending attended].freeze

  def attended?
    attended_at.present?
  end

  def attend!
    update(attended_at: Time.current)
  end

  def unattend!
    update(attended_at: nil)
  end

  def self.pending_count
    where(attended_at: nil).count
  end

  def self.for_filter(filter)
    scope = includes(:user, product: { photos_attachments: :blob })

    case filter
    when "pending"
      scope.where(attended_at: nil).order(Arel.sql("product_requests.created_at DESC, product_requests.id DESC"))
    when "attended"
      scope.where.not(attended_at: nil).order(Arel.sql("product_requests.created_at DESC, product_requests.id DESC"))
    else
      scope.order(Arel.sql("product_requests.attended_at IS NOT NULL, product_requests.created_at DESC, product_requests.id DESC"))
    end
  end
end
