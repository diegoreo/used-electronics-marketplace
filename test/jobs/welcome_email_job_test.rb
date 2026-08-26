require "test_helper"

class WelcomeEmailJobTest < ActiveJob::TestCase
  test "delivers the welcome email" do
    user = users(:pepe)

    WelcomeEmailJob.perform_later(user.id)

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal [user.email], ActionMailer::Base.deliveries.last.to
  end
end
