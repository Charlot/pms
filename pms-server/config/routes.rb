Rails.application.routes.draw do
  resources :tools

  resources :resource_group_parts do
    collection do
      get :group_by_part
    end
  end

  resources :machine_combinations

  resources :machine_scopes

  resources :machines do
    resource :machine_scope
    resources :machine_combinations
  end

  resources :resource_groups
  resources :resource_group_machines

  resources :resource_group_tools do
    # resources :resource_group_parts
    resource :resource_group_part
  end

  resources :process_parts

  resources :production_orders

  resources :process_entities do
    member do
      get :simple
    end
    collection do
      get :search
    end
  end

  resources :custom_values

  resources :custom_fields do
    collection do
      post :validate
    end
  end

  resources :process_templates do
    collection do
      get :template
    end
  end

  resources :kanbans do
    member do
      get :process_entities
      post :create_process_entities
      delete :destroy_process_entities
      get :history
      post :release
      post :lock
      delete :discard
      #post :scan
      get :manage
      get :search
      get :add_routing_template
    end

    collection do
      post :scan
    end
  end

  root :to => 'welcome#index'

  resources :part_boms do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :measure_units
  resources :parts do
    collection do
      get :search
    end
  end
  resources :files

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
