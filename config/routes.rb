Rails.application.routes.draw do

  devise_for :users

  get '/arrivals/arrivals_get', to: 'arrivals#arrivals_get'
  get '/arrivals/:token/:id/edit', to: 'arrivals#edit', as: :arrival_edit
  patch '/arrivals/:token/:id/update', to: 'arrivals#update', as: :arrival_update
  get '/arrivals/:token/new', to: 'arrivals#new', as: :arrival_new
  post '/arrivals/:token', to: 'arrivals#create', as: :arrival
  get '/arrivals/:token', to: 'arrivals#show', as: :arrivals
  get '/arrivals/:token/vehicles', to: 'arrivals#show_vehicles', as: :arrivals_vehicles

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  namespace :admin do
    root 'companies#index'
    get 'my-profile/edit', to: 'my_profile#edit'
    patch 'my-profile/update', to: 'my_profile#update'
    resources :companies, except: [:show] do
      resources :locations, except: [:show] do

        get 'refresh-token/:token_type', to: 'locations#refresh_token', as: :refresh_token, on: :member

      end
      resources :users, except: [:show] do
        member do
          get :toggle_activation
        end
      end
    end
  end
end
