require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = User.last
  end
  test "welcome" do
    mail = UserMailer.with(user: @user).welcome
    assert_equal "bienvenid@ a nuestro sitio web", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hey #{@user.username}, bienvenid@ a nuestra pagina web. Esperamos que tengas muchas ventas!", mail.body.encoded
  end
end
