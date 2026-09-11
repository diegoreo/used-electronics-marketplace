module ProductsHelper
  def product_og_image_url(product)
    if product.og_image
      rails_representation_url(product.og_image)
    else
      image_url("imagen por defecto.webp")
    end
  end
end
