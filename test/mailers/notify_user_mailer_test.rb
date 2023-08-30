require "test_helper"

class NotifyUserMailerTest < ActionMailer::TestCase
  test "shoe_limit_reached" do
    mail = NotifyUserMailer.shoe_limit_reached
    assert_equal "Shoe limit reached", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
