class ProductRequestsController < ApplicationController
  before_action :authorize!, only: [:index, :attend, :unattend]

  def index
    @filter = filter_param
    @product_requests = ProductRequest.for_filter(@filter)
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
    respond_with_updated_list(t(".attended"))
  end

  def unattend
    product_request.unattend!
    respond_with_updated_list(t(".unattended"))
  end

  private

  def filter_param
    ProductRequest::FILTERS.include?(params[:filter]) ? params[:filter] : "all"
  end

  def respond_with_updated_list(notice)
    filter = filter_param

    respond_to do |format|
      format.html { redirect_to product_requests_path(filter: filter == "all" ? nil : filter), notice: notice }
      format.turbo_stream do
        flash.now[:notice] = notice
        render turbo_stream: [
          turbo_stream.replace("product_requests_list", partial: "list", locals: { product_requests: ProductRequest.for_filter(filter), filter: filter }),
          turbo_stream.replace_all(".product-requests-badge", partial: "shared/product_requests_badge"),
          turbo_stream.replace("flash", partial: "shared/flash")
        ]
      end
    end
  end

  def product
    @product ||= Product.find(params[:product_id])
  end

  def product_request
    @product_request ||= ProductRequest.find(params[:id])
  end
end
