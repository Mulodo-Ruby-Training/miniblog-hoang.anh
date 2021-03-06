Rails.application.routes.draw do
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
  match '404', to: 'errors#not_found', via: :all
  match '500', to: 'errors#exception', via: :all

  namespace :v1, defaults: {format: 'json'} do

    get "posts/:id/comments", to: "posts#show_all_comments_post"
    get "posts/search/", to: "posts#search"

    #comment route
    post "comments", to: "comments#create"
    put "comments/:id", to: "comments#edit"
    delete "comments/:id", to: "comments#delete"

    #user route
    get "/users/search/", to: "users#search"
    get "/users/search/:keyword", to: "users#search"
    get "users/:id/posts", to: "users#show_posts_user"
    get "users/:id/posts_status_true", to: "users#show_posts_user_status_true"
    get "users/:id/comments", to: "users#show_all_comments_user"
    resources :users
    put "users/:id/password", to: "users#change_password"
    post "users/login", to: "users#login"
    post "users", to: "users#create"
    post "users/logout", to: "users#logout"

    #post route
    resources :posts
    post "posts", to: "posts#create"
    put "posts/:id/status", to: "posts#change_status"
    delete "posts/:id", to: "posts#destroy"
    
  end
end

