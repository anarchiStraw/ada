Ada::Application.routes.draw do

  resources :notice_settings , :except => ['edit', 'update'] do
    collection do
      post 'confirm'
    end
  end

  resources :test , :only => [] do
    collection do
      get 'create_youroom_user'
    end
  end
  

  root :to => 'sessions#menu'
  resources :oauth , :only => [] do
    collection do
      get  'verify_youroom'
      get  'callback_youroom'
      get  'verify_google'
      get  'callback_google'
    end
  end
  resources :google_accounts , :only => ['index', 'destroy']
  resources :notices
  resources :youroom_users

  match 'menu', :to => 'sessions#menu', :as => 'menu'
  
  match 'logout', :to => 'sessions#destroy', :as => 'logout'

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
