Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        get :profile, to: 'users/profiles#show'
      end
      get :feed, to: 'feeds#index'

      namespace :entries do
        resources :posts, :reposts, :quotes, only: [:create]
      end

      resources :follows, only: %i[create destroy]
    end
  end
end
