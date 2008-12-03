# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  def new
  end

  def create
    logout_keeping_session!
    account = Account.authenticate(params[:login], params[:password])
    if account
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_account = account
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:notice] = 'Utilisateur identifié avec succès.'
      redirect_back_or_default(root_path)
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = 'Vous venez d\'être déconnecté.'
    redirect_back_or_default(root_path)
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Impossible de vous identifier en tant que '#{params[:login]}'."
    logger.warn "Failed login for '#{params[:login]}' (account) from #{request.remote_ip} at #{Time.now.utc}."
  end
end
