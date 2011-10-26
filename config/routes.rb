Ada::Application.routes.draw do

  resources :test , :only => [] do
    collection do
      get 'create_youroom_user'
    end
  end
  

  root :to => 'home#index'
  resources :oauth , :only => [] do
    collection do
      get  'verify_youroom'
      get  'callback_youroom'
      get  'new_google_access_token'
      post 'request_google_access_token'
      get  'callback_google'
    end
  end
  resources :google_accounts
  resources :notices
  resources :youroom_users

  match 'menu', :to => 'sessions#menu', :as => 'menu'
  
  match 'logout', :to => 'sessions#destroy', :as => 'logout'

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
