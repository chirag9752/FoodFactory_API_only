Rails.application.routes.draw do

  root "hotels#index"

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

  post 'checkout/create_session', to: 'checkout#create_session'
  # config/routes.rb
  post 'webhooks/stripe', to: 'webhooks#stripe'


  resources :users do 
    resources :hotels do
      resources :menus
      resources :orders, except: [:update] do 
        resources :order_items, only: [:index, :show]
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
