SampleApp::Application.routes.draw do
  get "engine/run"
  match '/engine/log/:line', to: 'engine#log', via: 'get', as: :engine_log
  match '/engine/live', to: 'engine#live', via: 'get', as: :engine_live
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :matches
  resources :games
  resources :ais
  match '/games/:id/live', to: 'games#live', via: 'get', as: :live
  match '/games/:id/:log', to: 'games#viewlog', via: 'get', as: :viewlog  
  root  'static_pages#home'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/rules',   to: 'static_pages#rules',   via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/starterkit', to: 'static_pages#starterkit', via: 'get'
  match '/download/:id', to: 'static_pages#download', via: 'get', as: 'download'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  get 'elodata' => 'elo_data#history'



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
