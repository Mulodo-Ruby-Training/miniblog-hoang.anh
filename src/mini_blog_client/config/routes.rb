Rails.application.routes.draw do
  get "/", to: "posts#index"
  get "blog", to: "posts#all"
  get "write-my-new-post", to: "posts#new"
  get "edit-my-post/:id", to: "posts#edit"
  get "manage-my-posts",to: "posts#manage"
  get "posts/:id",to: "posts#detail"

  get "user-blog", to: "users#post"
  get "signup", to: "users#signup"
  get "signin", to: "users#signin"
  get "edit-my-account", to: "users#edit"
  get "change-my-password", to: "users#change_password"

  post "users/create", to: "users#create"
  post "users/login", to: "users#login"
  post "posts/create", to: "posts#create"
  post "posts/delete", to: "posts#delete"

  put "users/update", to: "users#update"
  put "users/update-password", to: "users#update_password"
  put "posts/update", to: "posts#update"

  get "logout", to: "users#logout"
  get "search-user/", to: "users#search"
  get "search-post/", to: "posts#search"


  # get "search-user/:keyword", to: "users#search"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'

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
