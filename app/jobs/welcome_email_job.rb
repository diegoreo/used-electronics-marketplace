class WelcomeEmailJob < ApplicationJob
  # Misma decisión intencional que FetchCountryJob: corre sobre Sidekiq,
  # no sobre Solid Queue (el default de la app).
  self.queue_adapter = :sidekiq
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.with(user: user).welcome.deliver_now
  end
end
