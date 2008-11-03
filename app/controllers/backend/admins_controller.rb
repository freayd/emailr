class Backend::AdminsController < Backend::BaseController
  def index
    @admins = Admin.all
  end

  def show
    @admin = Admin.find(params[:id])
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
      flash[:notice] = 'L\'administrateur a été créée avec succès.'
      redirect_back_or_default(admins_path)
    else
      flash[:error]  = 'Il est impossible d\'enregistrer cet administrateur. Veuillez réessayer.'
      render :action => 'new'
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    flash[:notice] = 'Administrateur supprimé avec succès.'
    redirect_to admins_path
  end
end
