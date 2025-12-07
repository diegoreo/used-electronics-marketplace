class FavoritesController < ApplicationController
  def index
    
  end
  
  def create
    #Favorite.create(product: product, user: Current.user) esto es igual a la linea siguiente.
    product.favorite!   #agregamos un metodo favorite! en concern product.rb
    respond_to do |format|
      format.html do
        redirect_to product_path(product)
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("favorite", partial: "products/favorite", locals: { product: product})
      end
    end
  end

  def destroy
    product.unfavorite! #agregamos el metodo unfavorit! en concern product.rb
    respond_to do |format|
      format.html do
        redirect_to product_path(product), status: :see_other
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("favorite", partial: "products/favorite", locals: { product: product})
      end
    end
  end

  private
  def product
    @product ||= Product.find(params[:product_id])
  end

end