# This controller handles the login/logout function of the site.  
class Backend::SessionsController < Backend::BaseController
  skip_before_filter :login_required, :only => [ :new, :create ]

  def new
  end

  def create
    logout_keeping_session!
    admin = Admin.authenticate(params[:login], params[:password])
    if admin
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_admin = admin
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default(backend_root_path)
      flash[:notice] = 'Administrateur identifié avec succès.'
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = 'Vous venez d\'être délogué.'
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts.
  def note_failed_signin
    flash[:error] = "Impossible de vous identifier en tant que '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
