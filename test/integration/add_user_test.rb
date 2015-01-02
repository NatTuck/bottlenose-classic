require 'test_helper'

class AddUserTest < ActionDispatch::IntegrationTest
  setup do
    @prof = users(:fred)
    
  end

  test "add a student" do
    # Log in as a professor
    visit "http://test.host/main/auth?email=#{@prof.email}&key=#{@prof.auth_key}"

    assert has_content?("Logged in as #{@prof.name}");

    click_link 'Your Courses'
    click_link 'Organization of Programming Languages'
    first(:link, 'Manage Registrations').click

    assert has_content?("Add a Student or Teacher")

    # Add a new student.
    fill_in 'Email', :with => 'steve@example.com'
    fill_in 'Name',  :with => 'Steve McTest'
    click_button 'Create Registration'

    # Verify that student was added.
    @steve = User.find_by_email('steve@example.com')
    assert_not_nil @steve
    assert_equal 'Steve McTest', @steve.name
    assert_equal 1, @steve.registrations.size
  end
end
