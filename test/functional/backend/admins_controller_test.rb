require 'test_helper'
require 'backend/admins_controller'

# Re-raise errors caught by the controller.
class Backend::AdminsController; def rescue_action(e) raise e end; end

class Backend::AdminsControllerTest < ActionController::TestCase

  def test_should_allow_signup
    assert_difference 'Admin.count' do
      create_admin
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:login => nil)
      assert assigns(:admin).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:password => nil)
      assert assigns(:admin).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:password_confirmation => nil)
      assert assigns(:admin).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:email => nil)
      assert assigns(:admin).errors.on(:email)
      assert_response :success
    end
  end


  # Routes.
  def test_should_use_admin_index_as_backend_root
    assert_recognizes({ :controller => 'backend/admins', :action => 'index' }, '/backend')
  end

  # GET actions.
  def test_should_show_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:admins)
  end
  def test_should_show_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:admin)
  end

  # POST actions.
  def test_should_add_admin
    create_admin
    assert ! assigns(:admin).new_record?
    assert_redirected_to admins_path
    assert_not_nil flash[:notice]
  end
  def test_should_reject_empty_email_on_signup
    create_admin(:email => nil)
    assert assigns(:admin).errors.on(:email)
    assert_response :success
    assert_template 'new'
    assert_not_nil flash[:error]
  end

  # HTML rendering.
  def test_should_show_admins_table
    get :index
    assert_select 'table tr', 4 # header + 3 admins
    assert_select "a[href=\"#{admin_signup_path}\"]"
  end
  def test_should_show_create_form
    get :new
    assert_select 'form input[type=text]',     2
    assert_select 'form input[type=password]', 2
    assert_select 'form input[type=submit]',   1
    assert_nil assigns(:admin).password
    assert_nil assigns(:admin).password_confirmation
  end


  protected
    def create_admin(options = {})
      post :create, :admin => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
