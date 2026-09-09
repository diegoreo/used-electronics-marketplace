class ProductRequestsController < ApplicationController
  before_action :authorize!, only: [:index, :attend, :unattend]

  def index
    @product_requests = ProductRequest.includes(:user, :product).order(created_at: :desc)
  end

  def create
    if Current.user.phone.blank?
      redirect_to product_path(product), alert: t(".missing_phone")
    else
      ProductRequest.create(user: Current.user, product: product)
      redirect_to product_path(product), notice: t(".created")
    end
  end

  def attend
    product_request.attend!
    redirect_to product_requests_path, notice: t(".attended")
  end

  def unattend
    product_request.unattend!
    redirect_to product_requests_path, notice: t(".unattended")
  end

  private

  def product
    @product ||= Product.find(params[:product_id])
  end

  def product_request
    @product_request ||= ProductRequest.find(params[:id])
  end
end
