require 'test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase

  def test_should_login_and_redirect
    post :create, :login => 'pierre', :password => 'monkey'
    assert session[:account_id]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'pierre', :password => 'bad password'
    assert_nil session[:account_id]
    assert_response :success
  end

  def test_should_logout
    login_as :pierre
    get :destroy
    assert_nil session[:account_id]
    assert_response :redirect
  end

  def test_should_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :login => 'pierre', :password => 'monkey', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :login => 'pierre', :password => 'monkey', :remember_me => "0"
    puts @response.cookies["auth_token"]
    assert @response.cookies["auth_token"].blank?
  end
  
  def test_should_delete_token_on_logout
    login_as :pierre
    get :destroy
    assert @response.cookies["auth_token"].blank?
  end

  def test_should_login_with_cookie
    accounts(:pierre).remember_me
    @request.cookies["auth_token"] = cookie_for(:pierre)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    accounts(:pierre).remember_me
    accounts(:pierre).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:pierre)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    accounts(:pierre).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end


  # Routes.
  def test_should_route_login
    assert_recognizes({ :controller => 'sessions', :action => 'new' }, login_path)
    assert_equal '/login', login_path
  end
  def test_should_route_logout
    assert_recognizes({ :controller => 'sessions', :action => 'destroy' }, { :path => logout_path, :method => :delete })
    assert_equal '/logout', logout_path
  end

  # GET actions.
  def test_should_show_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  # POST actions.
  def test_should_create_session
    create_session
    assert assigns(:current_account)
    assert_redirected_to root_path
    assert_not_nil flash[:notice]
  end
  def test_should_reject_empty_password_on_login
    create_session(:password => nil)
    assert_equal false, assigns(:current_account)
    assert_response :success
    assert_template 'new'
    assert_not_nil flash[:error]
  end

  # DELETE actions.
  def test_should_destroy_session
    login_as :pierre
    delete :destroy
    assert_equal false, assigns(:current_account)
    assert_redirected_to root_path
    assert_not_nil flash[:notice]
  end

  # HTML rendering.
  def test_should_show_login_form
    get :new
    assert_select '#content form input[type=text]',     1
    assert_select '#content form input[type=password]', 1
    assert_select '#content form input[type=submit]',   1
  end


  protected
    def create_session(options = {})
      post :create, { :login => 'pierre', :password => 'monkey' }.merge(options)
    end
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    def cookie_for(account)
      auth_token accounts(account).remember_token
    end
end
