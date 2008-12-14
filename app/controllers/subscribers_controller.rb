class SubscribersController < ApplicationController
  @@sub_menu << { :name => 'Liste',          :path => :subscribers        } \
             << { :name => 'Importation',    :path => :import_subscribers } \
             << { :name => 'Profils',        :path => :profiles           } \
             << { :name => 'Nouveau profil', :path => :new_profile        }


  def index
    @count       = current_customer.subscribers.size
    @subscribers = current_customer.subscribers.paginate(:page => params[:page], :order => 'identifier ASC')
  end

  def import
    if request.get?
      @auth_attr = Subscriber.authorized_attr_on_import
      return
    end

    errors = Subscriber.import(current_customer, params[:file], params[:separator])
    if errors.empty?
      flash[:notice] = 'Abonnés correctement importés et/ou mis à jour.'
    else
      flash[:error]  = 'Erreur lors de l\'importation des abonnés. Impossible d\'importer les lignes suivantes:'
      errors.each { |e| flash[:error] += "\n- l.#{e[:line]}: #{e[:message]}" }
    end
    redirect_to(subscribers_path)
  end

  def list
    profile = current_customer.profiles.build(params[:profile])

    profile.criteria.build(params[:criteria]) if params[:criteria]
    profile.criteria.reject! { |criterion| !criterion.valid? }

    @subscribers = profile.subscribers(:limit => 10)

    respond_to do |format|
      format.html { redirect_to(subscribers_path) }
      format.js # list.js.rjs
    end
  end
end
