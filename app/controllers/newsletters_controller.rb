class NewslettersController < ApplicationController
  @@sub_menu << { :name => 'Liste',   :path => :newsletters    } \
             << { :name => 'Nouveau', :path => :new_newsletter }


  def index
    @count       = current_customer.newsletters.size
    @newsletters = current_customer.newsletters.find(:all, :order => 'start_at ASC')
  end

  def new
    @newsletter = Newsletter.new(:start_at => Date.today, :frequency => 2, :frequency_unit => 'week')
  end

  def create
    @newsletter = current_customer.newsletters.build(params[:newsletter])
    if params[:profiles]
      profile_ids = params[:profiles].values.collect { |p| p['id'] }
      @newsletter.profiles = current_customer.profiles.find(profile_ids)
    end

    if @newsletter.save
      flash[:notice] = 'Votre newsletter à bien été enregistrée. Le prochain envoi est programmé.'
      redirect_to(newsletters_path)
    else
      flash[:error] = 'Une erreur est survenue lors de l\'enregistrement de votre newsletter.'
      render :action => 'new'
    end
  end

  def show
    @newsletter = current_customer.newsletters.find(params[:id])
  end

  def destroy
    current_customer.newsletters.destroy(params[:id])

    flash[:notice] = 'Newsletter supprimée avec succès.'
    redirect_to(newsletters_path)
  end
end
