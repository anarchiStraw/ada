Ada::Application.routes.draw do

  resources :notice_settings , :except => ['index', 'show', 'edit', 'update'] do
    new do
      post 'new'
    end
    collection do
      post 'confirm'
    end
  end

  resources :oauth , :only => [] do
    collection do
      get  'verify_youroom'
      get  'callback_youroom'
      get  'verify_google'
      get  'callback_google'
    end
  end

  resources :google_accounts , :only => ['destroy']

  root :to => 'sessions#home'
  match 'home', :to => 'sessions#home', :as => 'home'
  match 'logout', :to => 'sessions#destroy', :as => 'logout'
end
