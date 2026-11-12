class ProductsController < ApplicationController
  skip_before_action :protect_pages, only: [:index, :show]
  before_action :authorize!, only: [:new, :create]

  def index
    @categories = Category.order(name: :asc).load_async
    @featured_products = Product.featured.with_attached_photos
    @pagy, @products = pagy_countless(FindProducts.new.call(product_params_index).load_async, limit: 12)
  end

  def show
    # @product = Product.find(params[:id]) #se creo un metodo product para no repetir codigo
    product #se llamo al metodo product
    @conversation = Conversation.find_by(product: product, user: Current.user) if Current.user && !Current.user.admin?
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
    if product.update(product_params.except(:photos))   #se le quito @ a @product.update porque ahora lo jala del metodo
      product.photos.attach(product_params[:photos]) if product_params[:photos].present?
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

  def feature
    authorize! product
    product.feature!
    redirect_to product_path(product), notice: t(".featured")
  end

  def unfeature
    authorize! product
    product.unfeature!
    redirect_to product_path(product), notice: t(".unfeatured")
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :category_id, photos: [])
  end
  def product_params_index
    params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page, :favorites, :user_id )
  end

  def product
    @product ||= Product.find(params[:id])
  end
end