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
    @profile = Profile.new
  end

  def create
    @profile = current_customer.profiles.new(params[:profile])
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
    @profile = current_customer.profiles.find(params[:id])
  end

  def destroy
    @profile = current_customer.profiles.find(params[:id])
    @profile.destroy

    flash[:notice] = 'Profil supprimé avec succès.'
    redirect_to(profiles_path)
  end
end
