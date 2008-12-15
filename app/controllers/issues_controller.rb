class IssuesController < ApplicationController
  @@sub_menu << { :name => 'Liste',   :path => :newsletters    } \
             << { :name => 'Nouveau', :path => :new_newsletter }


  def new
    @newsletter = current_customer.newsletters.find(params[:newsletter_id])
    @issue = @newsletter.issues.build(:deliver_at    => params[:deliver_at],
                                      :email_title   => @newsletter.email_title,
                                      :email_content => @newsletter.email_content)
  end

  def create
    @newsletter = current_customer.newsletters.find(params[:newsletter_id])
    @issue = @newsletter.issues.build(params[:issue])
    if @issue.save
      flash[:notice] = 'Votre envoi à bien été enregistrée.'
      redirect_to(@newsletter)
    else
      flash[:error] = 'Une erreur est survenue lors de la sauvegarde de votre envoi.'
      render :action => 'new'
    end
  end

  def show
    @issue = current_customer.issues.find(params[:id])
  end
end
