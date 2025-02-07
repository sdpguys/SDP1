Rails.application.routes.draw do
  
  get "notifications/index"
  get "dashboard/index"
  resources :quizzes, only: [:index]
  
  resources :notifications, only: [ :index, :show, :destroy ]
  # API Endpoints
  get 'generate_quiz', to: 'quizzes#generate'
  post 'check_answers', to: 'quizzes#check_answers'

  namespace :admin do
    resources :notifications, only: [ :new, :create ]
  end
  resources :user_courses, only: [ :create, :destroy ]  # For adding and removing courses
  get "dashboard", to: "dashboard#index"             # Dashboard route
  resources :courses
  namespace :admin do
    get "notifications/new"
    get "notifications/create"
    get "users/index"
  end
  devise_for :users
  resources :courses do
    resources :weeks, only: [ :new, :create, :edit, :update, :destroy, :show ]
  end
  root "home#about" # Registration page as the homepage
  resources :users, only: [ :new, :create ]

  get "/home/about", to: "home#about"

  namespace :admin do
    resources :users, only: [ :index, :edit, :update, :destroy ]
  end

  resources :weeks do
    member do
      get "generate_quiz"
    end
  end

  resources :weeks do
    member do
      get :generate_quiz_html
    end
  end

  resources :courses do
    resources :weeks
  end




  post "/submit_quiz", to: "quizzes#submit"




  get "home/about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root "home#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
