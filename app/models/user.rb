class User < ApplicationRecord
  has_secure_password


  validates :email, presence: true, uniqueness: true,
   format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: :invalid
   }
  
  validates :username, presence: true, uniqueness: true,
   length: { in: 3..15 },
   format: {
      with: /\A[a-z0-9A-Z]+\z/,
      message: :invalid
   }
  validates :password, length: { minimum: 6 }, if: :password_digest_changed?
  validates :phone, presence: true,
   format: {
      with: /\A[\d\s\+\-\(\)]{7,20}\z/,
      message: :invalid
   }

  has_many :products, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :product_requests, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :messages, dependent: :destroy


  before_save :downcase_attributes

  private

  def downcase_attributes
    self.username = username.downcase
    self.email = email.downcase
  end

end
