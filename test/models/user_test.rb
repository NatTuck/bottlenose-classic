require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "email addresses are forced to lowercase" do
    bob = User.new(name: "Bob Dole", email: "Bob@example.com")
    bob.save!

    bob1 = User.find_by_email("bob@example.com");
    assert_equal bob1.email, "bob@example.com"
  end
end
