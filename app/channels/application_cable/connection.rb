module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # Puedes identificar usuarios aquí si usas sesiones, ej.:
    # identified_by :current_user

    # def connect
    #   self.current_user = find_verified_user
    # end
  end
end