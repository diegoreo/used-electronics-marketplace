class ProductPhotosController < ApplicationController
  def destroy
    authorize! product
    photo.purge
    redirect_to edit_product_path(product), notice: t(".destroyed")
  end

  private

  def product
    @product ||= Product.find(params[:product_id])
  end

  def photo
    @photo ||= product.photos.find(params[:id])
  end
end
