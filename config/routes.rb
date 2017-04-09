Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  authenticate :user, ->(u) { u.has_role? :admin} do
    mount Sidekiq::Web => '/sidekiq'
  end

  # 控制台
  namespace :admin do
    # 文章
    resources :topics

    # 图片
    resources :pictures
  end

  # 文章
  resources :topics, only: [:index, :show]

  resources :nodes, only: [:show]

  get 'notice' => 'notice#index'

  root to: "home#index"
end
