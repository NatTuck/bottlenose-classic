require 'test_helper'

class AuthMailerTest < ActionMailer::TestCase
  test "auth_link_email" do
    user = User.new(:email => "bob@example.com", :auth_key => "1234")
    mail = AuthMailer.auth_link_email(user)
    assert_equal ["bob@example.com"], mail.to
    assert_match %r{http://.*/main/auth\?email=bob%40example.com&key=1234},
      mail.body.encoded
  end

end
