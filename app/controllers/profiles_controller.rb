class ProfilesController < ApplicationController
  @@sub_menu << { :name => 'Liste',          :path => :subscribers        } \
             << { :name => 'Importation',    :path => :import_subscribers } \
             << { :name => 'Profils',        :path => :profiles           } \
             << { :name => 'Nouveau profil', :path => :new_profile        }


  def index
    @count    = current_customer.profiles.size
    @profiles = current_customer.profiles.find(:all, :order => 'name ASC')
  end

  def new
    respond_to do |format|
      format.html { @profile = current_customer.profiles.build             }
      format.js   { @profile = current_customer.profiles.find(params[:id]) } # new.js.rjs
    end
  end

  def create
    @profile = current_customer.profiles.build(params[:profile])
    @profile.criteria.build(params[:criteria]) if params[:criteria]
    if @profile.save
      flash[:notice] = 'Le profil à bien été enregistrée.'
      redirect_to(profiles_path)
    else
      flash[:error] = 'Une erreur est survenue lors de l\'enregistrement du profil.'
      render :action => 'new'
    end
  end

  def show
    @profile     = current_customer.profiles.find(params[:id])
    @subscribers = @profile.subscribers(:paginate => true, :page => params[:page], :order => 'identifier ASC')
  end

  def destroy
    current_customer.profiles.destroy(params[:id])

    flash[:notice] = 'Profil supprimé avec succès.'
    redirect_to(profiles_path)
  end
end
