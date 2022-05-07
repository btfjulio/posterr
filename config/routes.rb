Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        get :profile, to: 'users/profiles#show'
      end

      namespace :entries do
        resources :posts, :reposts, :quotes, only: [:create]
      end
    end
  end
end
