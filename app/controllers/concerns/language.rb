module Language
  extend ActiveSupport::Concern

  included do
    #se agrego el codigo siguiente para cambiar el idioma sde la peticion que se este haciendo, este jala el idioma que se tenga del navegador
    around_action :switch_locale

    private
    def switch_locale(&action)
      I18n.with_locale(locale_from_header, &action)
    end

    def locale_from_header
      request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    end
  end
end