# Contrôleur de base pour l'espace de nom 'backend'.
class Backend::BaseController < ApplicationController
  include AuthenticatedSystem

  before_filter :check_ip
  before_filter :login_required

  # Si l'IP n'est pas autorisée a accéder au backend, la méthode
  # relève une erreur de type ActionController::RoutingError
  # identique à celle jetée en cas de route inconnue.
  def check_ip
    authorized_ips = ApplicationConfig.value('backend.authorized_ips', nil).to_a
    return if authorized_ips.include?(request.remote_ip)
    # A ce point, l'IP n'est pas autorisée.

    path = request.path
    environment = ActionController::Routing::RouteSet.new.extract_request_environment(request)
    logger.warn "#{request.remote_ip.inspect} trying to access backend without permissions at #{Time.now.utc.inspect}"
    raise ActionController::RoutingError, "No route matches #{path.inspect} with #{environment.inspect}"
  end
end
