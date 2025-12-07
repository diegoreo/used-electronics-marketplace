class ApplicationController < ActionController::Base
  # code for the pagination gem, Include it in the controllers
  include Authentication
  include Authorization
  include Language
  include Pagy::Backend
  include Error

end
