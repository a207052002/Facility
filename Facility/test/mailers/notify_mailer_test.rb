require 'test_helper'

class NotifyMailerTest < ActionMailer::TestCase
  test "notify_rent" do
    mail = NotifyMailer.notify_rent
    assert_equal "Notify rent", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
