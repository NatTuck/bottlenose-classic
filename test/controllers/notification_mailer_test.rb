require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:ken)
    @fred = users(:fred)
    @req  = reg_requests(:guest_req)
  end

  test "got_reg_request" do
    mail = NotificationMailer.got_reg_request(@fred, @req, 
                                              "http://example.com")
    assert_match "Hi", mail.body.encoded
  end

end
