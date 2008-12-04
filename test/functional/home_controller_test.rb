require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  # Routes.
  def test_should_route_home
    assert_recognizes({ :controller => 'home', :action => 'index' }, root_path)
    assert_equal '/', root_path
  end

  # GET actions.
  def test_should_show_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  # HTML rendering.
  def test_should_show_logo
    get :index
    assert_select '#logo a[href=?] img[src^=?]', root_url, '/images/emailr.png', 1
  end
  def test_should_show_login_form
    get :index
    assert_select '#user_area form input[type=text]',     1
    assert_select '#user_area form input[type=password]', 1
    assert_select '#user_area form input[type=submit]',   1
  end
  def test_should_show_menu
    get :index
    assert_select '#menu li a[href]', :minimum => 2
  end

end
