module Favoritable
  extend ActiveSupport::Concern

  included do
    has_many :favorites, dependent: :destroy
    def favorite!
      favorites.create(user: Current.user)  #este metodo crea un favorito para un producto del usuario logeado
    end
  
    def unfavorite!
      favorite.destroy #este metodo elimina el favorito al producto del usuario logeado
    end
  
    def favorite
      favorites.find_by(user: Current.user)  #busca el favorito del producto actual que pertenece al usuario que esta logeado
    end
  
  end
end