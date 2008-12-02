module AuthenticatedTestHelper
  # Sets the current account in the session from the account fixtures.
  def login_as(account)
    @request.session[:account_id] = account ? accounts(account).id : nil
  end

  def authorize_as(account)
    @request.env["HTTP_AUTHORIZATION"] = account ? ActionController::HttpAuthentication::Basic.encode_credentials(accounts(account).login, 'monkey') : nil
  end

  # Sets the current admin in the session from the admin fixtures.
  def login_as_admin(admin)
    @request.session[:admin_id] = admin ? admins(admin).id : nil
  end

  def authorize_as_admin(admin)
    @request.env["HTTP_AUTHORIZATION"] = admin ? ActionController::HttpAuthentication::Basic.encode_credentials(admins(admin).login, 'monkey') : nil
  end
  
end
