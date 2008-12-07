require 'yaml'
require 'core_ext/hash'
require 'core_ext/yaml'

# Fichiers de configuration de l'application.
common_file = "#{RAILS_ROOT}/config/application/common.yml"
env_file    = "#{RAILS_ROOT}/config/application/#{RAILS_ENV}.yml"

# Charge les données de configuration de l'application.
# Les données du fichier commun sont écrasées par celles de l'environnement.
yaml_data = Hash.new
[ common_file, env_file ].each do |config_file|
  yaml_data.deep_merge!(YAML::erb_load_file(config_file)) if File.exists?(config_file)
end

# Classe contenant les données de configuration de l'application.
class << ::ApplicationConfig = yaml_data.gather!
  alias :defined? :has_key?
  alias :value    :fetch
end


# Configurations.
ActionMailer::Base.default_url_options[:host] = ApplicationConfig['application.host']

