require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "lost auth form should create admin on fresh install" do
    ken_email = users(:ken).email
    
    User.delete_all
    assert_equal User.count, 0, "should start with no users"
    
    num_deliveries = ActionMailer::Base.deliveries.size
    
    post :resend_auth, :email => ken_email
    
    assert_equal ActionMailer::Base.deliveries.size, num_deliveries + 1, 
      "email should be sent"
    
    assert_equal User.count, 1, "new user should be created"
    
    ken = User.find_by_email(ken_email)
    assert ken.site_admin?, "new user should be site admin"
    
    assert_redirected_to root_url
  end
  
  test "lost auth form should resend auth email" do
    num_deliveries = ActionMailer::Base.deliveries.size
    
    post :resend_auth, :email => users(:alan).email
    
    assert_equal ActionMailer::Base.deliveries.size, num_deliveries + 1, 
      "email should be sent"
    
    assert_redirected_to root_url
  end
  
  test "user can log in" do
    post :auth, {:email => users(:alan).email, :key => users(:alan).auth_key}
    assert_match "Logged in", flash[:notice]
    assert_equal session[:user_id], users(:alan).id
    
    assert_response(:success)
  end
  
  test "John can't log in as Alan" do
    post :auth, {:email => users(:alan).email, :key => users(:john).auth_key}
    assert_match "Authentication failed", flash[:error]
    assert_nil session[:user_id]
    
    assert_redirected_to '/'
  end
  
  test "user can log out" do
    get :logout
    assert_nil session[:user_id]

    assert_redirected_to '/'
  end
end
