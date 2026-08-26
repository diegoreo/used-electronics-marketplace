class ProductsController < ApplicationController
  skip_before_action :protect_pages, only: [:index, :show]
  before_action :authorize!, only: [:new, :create]

  def index
    @categories = Category.order(name: :asc).load_async
    # todo este codigo fue remplazado por el doc queries>find_products.rb aqui se encuentran todos los filtros
    #@products = Product.with_attached_photo
    #if params[:category_id]
    #  @products = @products.where(category_id: params[:category_id])
    #end
    #if params[:min_price].present?
    #  @products = @products.where("price >= ?", params[:min_price])
    #end
    #if params[:max_price].present?
    #  @products = @products.where("price <= ?", params[:max_price])
    #end
    #if params[:query_text].present?
    #  @products = @products.search_full_text(params[:query_text])
    #end
    #order_by = Product::ORDER_BY.fetch(params[:order_by]&.to_sym, Product::ORDER_BY[:newest])
    #@products = @products.order(order_by).load_async

    @pagy, @products = pagy_countless(FindProducts.new.call(product_params_index).load_async, limit: 12)  #se remplazo @products por FindProducts.new.call(params).load_async  el codigo nuevo que esta en find_products.rb
   

    
  end

  def show
    # @product = Product.find(params[:id]) #se creo un metodo product para no repetir codigo
    product #se llamo al metodo product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: t(".created") #"Tu producto se ha creado correctamente"    se agrego traduccion con t(".created")
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
    authorize! product
    #@product = Product.find(params[:id]) #se creo un metodo product para no repetir codigo
    #product  #se llama al metodo product
  end

  def update
    authorize! product
    # @product = Product.find(params[:id])   se creo metodo product para no repetir codigo
    if product.update(product_params)   #se le quito @ a @product.update porque ahora lo jala del metodo
      # notify_all_users  se  remplazara por turbo product.broadcast
      product.broadcast
      redirect_to products_path, notice: t(".updated") #"Tu producto se ha actualizado correctamente" se agrego traduccion con t(".update") las traducciones estan en es.yml
    else
     render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    authorize! product
   # @product = Product.find(params[:id])  se creo metodo product para no repetir
    product.destroy     #se le quito @ a @product.destroy porque ahora lo jalamos de un metodo product
    redirect_to products_path, notice: t(".destroyed"), status: :see_other #"Tu producto se ha eliminado correctamente" se agrego traduccion con t(".update") las traducciones estan en es.yml
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id)
  end
  def product_params_index
    params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page, :favorites, :user_id )
  end

  def product
    @product ||= Product.find(params[:id])
  end

# se elimino este metodo por product.broadcast
 # def notify_all_users
 #   ActionCable.server.broadcast(
 #     "product_#{product.id}",
 #     {
 #       action: "updated"
 #     }
 #   )
 # end
end