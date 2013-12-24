require 'sidekiq/web'

TShirts::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  root to: 't_shirts#index'

  resources :t_shirts, only: [:index, :show]
end