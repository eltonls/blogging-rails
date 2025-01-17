Rails.application.routes.draw do
  resource :session
  resource :passwords, only: [ :new, :create, :edit, :update ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "posts#index"

  get "/signup", to: "users#new", as: :signup_path
  post "/signup", to: "users#create"
  get "/profile", to: "users#show", as: :profile_path
  get "/profile/edit", to: "users#edit", as: :profile_edit_path
  put "/user", to: "users#update", as: :user_update_path

  get "/login", to: "sessions#new", as: :login_path

  get "/confirm_email/:token", to: "confirmation#confirm", as: :confirm_email

  resources :posts do
    resources :comments, only: [ :create ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
