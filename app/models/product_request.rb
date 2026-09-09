class ProductRequest < ApplicationRecord
  belongs_to :user
  belongs_to :product

  def attended?
    attended_at.present?
  end

  def attend!
    update(attended_at: Time.current)
  end

  def unattend!
    update(attended_at: nil)
  end
end
