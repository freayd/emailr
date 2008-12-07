class AccountsController < ApplicationController
  skip_before_filter :login_required, :only => [ :new, :create, :activate ]

  def new
    @customer = Customer.new
    @account = @customer.accounts.new
    @account.password = @account.password_confirmation = nil
  end
 
  def create
    logout_keeping_session!
    @customer = Customer.new(params[:customer])
    @account = @customer.accounts.build(params[:account])
    success = @customer && @account && @customer.save
    if success && @customer.errors.empty? && @account.errors.empty?
      flash[:notice] = 'Merci de vous être enregistré. Nous venons de vous envoyer une email avec votre code d\'activation du compte principal.'
      redirect_back_or_default(root_path)
    else
      flash[:error]  = 'Nous ne pouvons enregistrer ce compte. Veuillez corriger les informations. ' +
                       'En cas de problème, veuillez contactez l\'administrateur du site.'
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    account = Account.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && account && !account.active?
      account.activate!
      flash[:notice] = 'Votre compte vient d\'être activé. Veuillez vous connecter afin de continuer.'
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = 'Le code d\'activation est manquant. Veuillez suivre le lien qui vous a été envoyé par email.'
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = 'Ce code d\'activation est erroné. Avez vous déjà activé votre vompte ? Essayez de vous connecter.'
      redirect_back_or_default(root_path)
    end
  end
end
