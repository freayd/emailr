ActionController::Routing::Routes.draw do |map|
  map.resource :session, :only => [ :new, :create, :destroy ]
  map.login    '/login',    :controller => 'sessions', :action => 'new',     :conditions => { :method => :get    }
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy', :conditions => { :method => :delete }

  map.resources :accounts, :only => [ :new, :show, :create ]
  map.signup   '/signup',                    :controller => 'accounts', :action => 'new',    :conditions => { :method => :get  }
  map.register '/register',                  :controller => 'accounts', :action => 'create', :conditions => { :method => :post }
  map.activate '/activate/:activation_code', :controller => 'accounts', :action => 'activate', :activation_code => nil

  map.resources :subscribers, :only   => :index,             :collection => { :import => [ :get, :post ], :list => :post }
  map.resources :profiles,    :except => [ :edit, :update ], :path_prefix => '/subscribers'
  map.resources :criteria,    :only   => :new,               :path_prefix => '/subscribers/profiles'

  map.resources :newsletters, :except => [ :edit, :update ] do |newsletter|
    newsletter.resources :issues, :only => [ :new, :create, :show ] do |issue|
      issue.preview 'preview', :controller => 'issues', :action => 'preview', :conditions => { :method => :get }
    end
  end

  map.with_options :controller => 'logger', :conditions => { :method => :get } do |logger|
    logger.email_opened_logger  'logger/email_opened',  :action => 'email_opened'
    logger.email_forward_logger 'logger/email_forward', :action => 'email_forward'
    logger.tracking_logger      'logger/tracking',      :action => 'tracking'
  end

  map.with_options :controller => 'tracking', :conditions => { :method => :get } do |track|
    track.tracking          'tracking',                   :action => 'index'
    track.emailing_log      'tracking/log/emailing',      :action => 'emailing_log'
    track.emailing_link_log 'tracking/log/emailing_link', :action => 'emailing_link_log'
    track.tracking_log      'tracking/log/tracking',      :action => 'tracking_log'
  end

  map.with_options :controller => 'stats', :conditions => { :method => :get } do |st|
    st.stats 'stats', :action => 'index'
  end

  map.namespace :backend do |backend|
    backend.resource :session, :only => [ :new, :create, :destroy ]
    backend.login  '/login',  :controller => 'sessions', :action => 'new',     :name_prefix => 'admin_', :conditions => { :method => :get    }
    backend.logout '/logout', :controller => 'sessions', :action => 'destroy', :name_prefix => 'admin_', :conditions => { :method => :delete }

    backend.resources :admins, :name_prefix => nil, :except => [ :edit, :update ]
    backend.signup   '/signup',   :controller => 'admins', :action => 'new',    :name_prefix => 'admin_', :conditions => { :method => :get  }
    backend.register '/register', :controller => 'admins', :action => 'create', :name_prefix => 'admin_', :conditions => { :method => :post }

    backend.root :controller => 'admins', :conditions => { :method => :get }
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => 'home', :conditions => { :method => :get }

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
