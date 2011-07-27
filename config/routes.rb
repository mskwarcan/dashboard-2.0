Bdashd::Application.routes.draw do
  resources :accounts

  devise_for :users
  
  devise_scope :user do
    match "/users/sign_out", :controller => 'devise/sessions', :action => 'destroy'
  end

  root :to => "accounts#home"
  
  match '/accounts' => "account#index", :as => :user_root
  
  match '/accounts/:id/update_list', :controller => 'accounts', :action => 'update_lists'
  match '/accounts/:id/remove_fb', :controller => 'accounts', :action => 'remove_facebook'
  match '/accounts/:id/remove_twitter', :controller => 'accounts', :action => 'remove_twitter'
  match '/accounts/:id/remove_google', :controller => 'accounts', :action => 'remove_google'
  match '/accounts/:id/remove_mc', :controller => 'accounts', :action => 'remove_mailchimp'
  match '/accounts/:id/users', :controller => 'accounts', :action => 'users'
  match '/accounts/:id/add_user', :controller => 'accounts', :action => 'add_user'
  match '/accounts/:id/add_connection', :controller => 'accounts', :action => 'add_connection'
  match '/accounts/:id/remove_connection', :controller => 'accounts', :action => 'remove_connection'
  match '/accounts/:id/:user_id/remove_user', :controller => 'accounts', :action => 'remove_user_connection'
  
  match '/facebook', :controller => 'accounts', :action => 'facebook_register'
  match '/facebook_callback', :controller => 'accounts', :action => 'facebook_callback'
  
  match '/twitter', :controller => 'accounts', :action => 'twitter_register'
  match '/twitter_callback', :controller => 'accounts', :action => 'twitter_callback'
  
  match '/google', :controller => 'accounts', :action => 'google_register'
  match '/google_callback', :controller => 'accounts', :action => 'google_callback'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
