class SubscribersController < ApplicationController
  @@sub_menu << { :name => 'Liste',       :path =>:subscribers        } \
             << { :name => 'Importation', :path =>:import_subscribers }


  def index
    @count = current_customer.subscribers.size
    @subscribers = current_customer.subscribers.find(:all, :order => 'identifier ASC')
  end

  def import
    if request.get?
      auth_attr = Subscriber.authorized_attr_on_import.to_sentence(:connector => 'et', :skip_last_comma => true)
      flash[:notice] = "Les colonnes doivent être spécifiées en en-tête.\n" \
                       "Liste des colonnes possibles : #{auth_attr}.\n" \
                       "La colonne 'identifier' est obligatoire. Un email ne peut être dupliqué."
      return
    end

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
