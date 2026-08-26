ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'webmock/minitest'
require "sidekiq/testing"

# Permite tráfico local (Capybara/Selenium hablando con chromedriver) sin
# habilitar conexiones de red reales — sigue bloqueando cualquier HTTP externo.
WebMock.disable_net_connect!(allow_localhost: true)

# FetchCountryJob y WelcomeEmailJob corren sobre Sidekiq a propósito (ver
# config/application.rb) — inline! los ejecuta en el momento, en el mismo
# proceso, sin tocar Redis real.
Sidekiq::Testing.inline!

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login(user = users(:paco))
      post sessions_path, params: { login: user.email, password: "testme" }
    end
  end
end
