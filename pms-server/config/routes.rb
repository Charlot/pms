require 'devise'
Rails.application.routes.draw do
  resources :production_order_handler_items

  resources :production_order_handlers

  resources :production_order_item_labels

  root :to => 'welcome#index'

  # devise_for :users, controllers: {
  #                sessions: 'users/sessions'
  #                  }

  devise_for :users, :controllers => { registrations: :user_registrations}

  devise_scope :user do
    get '/users/sign_out' => 'user_sessions#destroy'
    post '/user_sessions/locale' => 'user_sessions#locale'
    get '/user_sessions/new' => 'user_sessions#new'
    post '/user_sessions/' => 'user_sessions#create'
    get '/user_sessions/destroy' => 'user_sessions#destroy'
    delete '/api/user_sessions/' => 'user_sessions#destroy'
    post '/api/user_sessions/' => 'user_sessions#create'
    get '/user_sessions/finish_guide' => 'user_sessions#finish_guide'
  end

  resources :users do
    collection do
      get :scope_search
    end
  end
  resources :positions
  resources :ncr_api_logs

  resources :machine_time_rules do
    collection do
      match :import, to: :import,via: [:get,:post]
    end
  end

  resources :machine_types

  resources :oee_codes

  resources :warehouses do
    resources :positions
  end

  resources :storages do
    collection do
      get :scope_search
    end
  end


  resources :part_positions do
    collection do
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :master_bom_items do
    collection do
      match :import, to: :import, via: [:get, :post]
      match :transport, to: :transport, via: [:get, :post]
      match :export, to: :export, via: [:get, :post]
      get :search
      match :import_delete,to: :import_delete,via:[:get,:post]
    end
  end

  resources :departments

  # resources :master_bom_items do
  #   collection do
  #     match :import, to: :import, via: [:get, :post]
  #   end
  # end

  resources :kanban_process_entities

  resources :production_order_items do
    resources :production_order_item_labels
    collection do
      get :search
      post :optimise
      post :distribute
      post :export
      post :export_scand
      post :move
      post :change_state
      post :set_urgent
      match :state_export, to: :state_export, via: [:get, :post]
    end
  end


  resources :production_orders do
    resources :production_order_items

    collection do
      get :preview
    end
  end

  resources :production_order_item_blues do
    collection do
      get :search
      post :distribute
      post :export
      post :export_scand
    end
  end


  resources :production_order_blues do
    resources :production_order_item_blues
    collection do
      get :search
    end
  end

  resources :settings

  resources :tools do
    collection do
      get :scope_search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :resource_group_parts do
    collection do
      get :group_by_part
    end
  end

  mount ApplicationAPI => '/'

  resources :machine_combinations do
    collection do
      get :export
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :machine_scopes

  resources :machines do
    resource :machine_scope
    resources :machine_combinations

    collection do
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :resource_groups
  resources :resource_group_machines

  resources :resource_group_tools do
    # resources :resource_group_parts
    resources :resource_group_parts
  end

  resources :process_parts

  resources :process_entities do
    member do
      get :simple
    end
    collection do
      get :search
      get :scope_search
      get :export_auto
      get :export_semi
      match :import_auto, to: :import_auto, via: [:get, :post]
      match :import_semi_auto, to: :import_semi_auto, via: [:get, :post]
      get :export_unused
    end
  end

  resources :custom_values do
    collection do
      post :updates
    end
  end

  resources :custom_fields do
    collection do
      post :validate
    end
  end

  resources :process_templates do
    collection do
      get :search
      get :template
      post :autoimport
      post :semiautoimport
      post :manual_import
      match :import, to: :import, via: [:get, :post]
      get :scope_search
    end
  end

  resources :kanbans do
    member do
      get :history
      post :release
      post :lock
      delete :discard
      get :add_routing_template
      delete :delete_process_entities
      post :add_process_entities
      get :manage_routing
    end

    collection do
      post :scan
      get :panel
      get :scope_search
      get :export
      get :export_white
      get :management
      match :import, to: :import, via: [:get, :post]
      match :scan_finish, to: :scan_finish, via: [:get, :post]
      match :import_to_scan, to: :import_to_scan, via: [:get, :post]
      match :import_to_finish_scan, to: :import_to_finish_scan, via: [:get, :post]
      match :import_to_get_kanban_list, to: :import_to_get_kanban_list, via: [:get, :post]
      match :import_update_quantity, to: :import_update_quantity, via: [:get, :post]
      match :import_update_base, to: :import_update_base, via: [:get, :post]
      match :import_lock, to: :import_lock, via: [:get, :post]
      match :import_unlock, to: :import_unlock, via: [:get, :post]
      match :transport, to: :transport, via: [:get, :post]
    end
  end



  resources :part_boms do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :measure_units
  resources :parts do
    member do
      #post :add_process_entities
      #delete :delete_process_entities
    end
    collection do
      get :search
      get :scope_search
      match :import, to: :import, via: [:get, :post]
      match :import_update, to: :import_update, via: [:get, :post]
      get :export
      match :search, to: :search, via: [:get, :post]
    end
  end
  resources :files


  require 'sidekiq/web'
  # authenticate :user, lambda { |u| u.is_sys } do
  mount Sidekiq::Web => '/sidekiq'
  # end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
