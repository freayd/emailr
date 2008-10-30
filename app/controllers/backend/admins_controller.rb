class Backend::AdminsController < Backend::BaseController
  def index
    @admins = Admin.all
  end

  def new
    @admin = Admin.new
    @admin.password = @admin.password_confirmation = nil
  end
 
  def create
    logout_keeping_session!
    @admin = Admin.new(params[:admin])
    success = @admin && @admin.save
    if success && @admin.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_admin = @admin # !! now logged in
      redirect_back_or_default(admins_path)
      flash[:notice] = 'L\'administrateur a été créée avec succès.'
    else
      flash[:error]  = 'Il est impossible d\'enregistrer cet administrateur. Veuillez réessayer.'
      render :action => 'new'
    end
  end
end
