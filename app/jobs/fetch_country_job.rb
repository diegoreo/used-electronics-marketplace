class FetchCountryJob < ApplicationJob
  # Corre sobre Sidekiq a propósito, no sobre Solid Queue (el default de la
  # app) — decisión intencional para seguir usando Sidekiq en casos puntuales.
  self.queue_adapter = :sidekiq
  queue_as :default

  def perform(user_id, ip)
    country = FetchCountryService.new(ip).perform
    if country
      user = User.find(user_id)
      user.update(country: country)
    end
  end
end
