require "test_helper"

class FetchCountryJobTest < ActiveJob::TestCase
  test "updates the user's country from their IP" do
    user = users(:pepe)
    stub_request(:get, "http://ip-api.com/json/24.48.0.1").
      to_return(status: 200, body: { status: "success", countryCode: "CA" }.to_json, headers: {})

    FetchCountryJob.perform_later(user.id, "24.48.0.1")

    assert_equal "ca", user.reload.country
  end
end
