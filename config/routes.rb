Ada::Application.routes.draw do
  root :to => 'home#index'
  resources :oauth , :only => [] do
    collection do
      get 'verify_youroom'
      get 'callback_youroom'
    end
  end
  resources :notices
  match 'logout', :to => 'sessions#destroy', :as => 'logout'

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
