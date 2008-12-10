require 'test_helper'
require 'backend/admins_controller'

# Re-raise errors caught by the controller.
class Backend::AdminsController; def rescue_action(e) raise e end; end

class Backend::AdminsControllerTest < ActionController::TestCase

  def test_should_allow_signup
    login_as_admin :quentin
    assert_difference 'Admin.count' do
      create_admin
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    login_as_admin :quentin
    assert_no_difference 'Admin.count' do
      create_admin(:login => nil)
      assert assigns(:admin).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    login_as_admin :quentin
    assert_no_difference 'Admin.count' do
      create_admin(:password => nil)
      assert assigns(:admin).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    login_as_admin :quentin
    assert_no_difference 'Admin.count' do
      create_admin(:password_confirmation => nil)
      assert assigns(:admin).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    login_as_admin :quentin
    assert_no_difference 'Admin.count' do
      create_admin(:email => nil)
      assert assigns(:admin).errors.on(:email)
      assert_response :success
    end
  end


  # Routes.
  def test_should_route_backend_root
    assert_recognizes({ :controller => 'backend/admins', :action => 'index' }, backend_root_path)
    assert_equal '/backend', backend_root_path
  end
  def test_should_redirect_if_not_logged_in
    get :index
    assert_redirected_to admin_login_path
  end
  def test_should_route_signup
    assert_recognizes({ :controller => 'backend/admins', :action => 'new' }, admin_signup_path)
    assert_equal '/backend/signup', admin_signup_path
  end
  def test_should_route_register
    assert_recognizes({ :controller => 'backend/admins', :action => 'create' }, { :path => admin_register_path, :method => :post })
    assert_equal '/backend/register', admin_register_path
  end

  # GET actions.
  def test_should_show_index
    login_as_admin :quentin
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:admins)
  end
  def test_should_show_admin
    login_as_admin :quentin
    get :show, :id => admins(:quentin)
    assert_response :success
    assert_template 'show'
    assert_equal admins(:quentin), assigns(:admin)
  end
  def test_should_show_new
    login_as_admin :quentin
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:admin)
  end

  # POST actions.
  def test_should_add_admin
    login_as_admin :quentin
    create_admin
    assert ! assigns(:admin).new_record?
    assert_redirected_to admins_path
    assert_not_nil flash[:notice]
    # Vérifie que le current_admin n'a pas changé.
    assert_equal admins(:quentin), assigns(:current_admin)
  end
  def test_should_reject_empty_email_on_signup
    login_as_admin :quentin
    create_admin(:email => nil)
    assert assigns(:admin).errors.on(:email)
    assert_response :success
    assert_template 'new'
    assert_not_nil flash[:error]
  end

  # DELETE actions.
  def test_should_destroy_admin
    login_as_admin :quentin
    delete :destroy, :id => admins(:aaron)
    assert_equal admins(:aaron), assigns(:admin)
    assert ! Admin.exists?(assigns(:admin))
    assert_redirected_to admins_path
    assert_not_nil flash[:notice]
    # Vérifie que le current_admin n'a pas changé.
    assert_equal admins(:quentin), assigns(:current_admin)
  end
  def test_should_destroy_current_admin
    login_as_admin :quentin
    delete :destroy, :id => admins(:quentin)
    assert ! Admin.exists?(admins(:quentin))
    assert_response :redirect
   end

  # HTML rendering.
  def test_should_show_admin_area
    login_as_admin :quentin
    get :index
    assert_select 'div#user_area a[href=?]', admin_path(admins(:quentin)), admins(:quentin).login
    assert_select 'div#user_area a', 'Déconnexion'
  end
  def test_should_not_show_admin_area
    get :index
    assert_select 'div#user_area', false
  end
  def test_should_show_admins_table
    login_as_admin :quentin
    get :index
    assert_select 'table tr', 4 # header + 3 admins
    assert_select 'table tr td', 'quentin' # login
    assert_select 'table tr td', 'quentin@example.com' # email
    assert_select 'a[href=?]', admin_signup_path
  end
  def test_should_show_admin_details
    login_as_admin :quentin
    get :show, :id => admins(:aaron)
    assert_select 'p', /aaron/
    assert_select 'p', /aaron@example\.com/
    assert_select 'a[href=?]', admins_path
  end
  def test_should_show_create_form
    login_as_admin :quentin
    get :new
    assert_select 'form input[type=text]',     2
    assert_select 'form input[type=password]', 2
    assert_select 'form input[type=submit]',   1
    assert_nil assigns(:admin).password
    assert_nil assigns(:admin).password_confirmation
    assert_select 'a[href=?]', admins_path
  end


  protected
    def create_admin(options = {})
      post :create, :admin => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
