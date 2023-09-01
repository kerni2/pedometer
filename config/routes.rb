Rails.application.routes.draw do
  authenticated :user do
    root 'activities#index', as: :authenticated_root
  end

  root 'static_pages#home'
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :activities
  resources :totals, only: [:index]
  resources :shoes
end
