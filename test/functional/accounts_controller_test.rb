require 'test_helper'
require 'accounts_controller'

# Re-raise errors caught by the controller.
class AccountsController; def rescue_action(e) raise e end; end

class AccountsControllerTest < ActionController::TestCase

  def test_should_allow_signup
    assert_difference 'Account.count' do
      create_account
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Account.count' do
      create_account(:login => nil)
      assert assigns(:account).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Account.count' do
      create_account(:password => nil)
      assert assigns(:account).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Account.count' do
      create_account(:password_confirmation => nil)
      assert assigns(:account).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Account.count' do
      create_account(:email => nil)
      assert assigns(:account).errors.on(:email)
      assert_response :success
    end
  end
  

  
  def test_should_sign_up_user_with_activation_code
    create_account
    assigns(:account).reload
    assert_not_nil assigns(:account).activation_code
  end

  def test_should_activate_user
    assert_nil Account.authenticate('paul', 'test')
    get :activate, :activation_code => accounts(:paul).activation_code
    assert_redirected_to login_path
    assert_not_nil flash[:notice]
    assert_equal accounts(:paul), Account.authenticate('paul', 'monkey')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  protected
    def create_account(options = {})
      customer_attr = { :company => 'compaMy', :address => '1 test av.', :city => 'Nowhere', :postal_code => '+12345',
                        :country => 'Isle of test', :phone_number => '+' }
      account_attr  = { :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }
      post :create, :customer => customer_attr, :account => account_attr.merge(options)
    end
end
