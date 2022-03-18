Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "static_pages/home"
    get "static_pages/help"
    get "static_pages/contact"
    get "static_pages/about"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "authentication#authenticate"
      post "auth/logout", to: "authentication#logout"
      post "signup", to: "users#create"
      post "update-info", to: "users#update"
      resources :microposts, only: %i(index show)
    end
  end
end
