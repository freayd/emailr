class SubscribersController < ApplicationController
  @@sub_menu << { :name => 'Importatation', :path =>:import_subscribers }


  def index
  end

  def import
    return unless request.post?

    errors = Subscriber.import(current_customer, params[:file], params[:separator])
    if errors.empty?
      flash[:notice] = 'Abonnés correctement importés et/ou mis à jour.'
    else
      flash[:error]  = 'Erreur lors de l\'importation des abonnés. Impossible d\'importer les lignes suivantes:'
      errors.each { |e| flash[:error] += "\n- l.#{e[:line]}: #{e[:message]}" }
    end
    redirect_to subscribers_path
  end
end
