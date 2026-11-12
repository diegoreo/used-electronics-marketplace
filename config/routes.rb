Rails.application.routes.draw do
  namespace :authentication, path: "", as: "" do
    resources :users, only: [:new, :create], path: "/register", path_names: { new: "/"}
    resources :sessions, only: [:new, :create, :destroy], path: "/login", path_names: { new: "/"}
  end

  resources :favorites, only: [:index, :create, :destroy], param: :product_id
  resources :product_requests, only: [:index, :create] do
    member do
      patch :attend
      patch :unattend
    end
  end
  resources :users, only: :show, path: "/user", param: :username
  resources :categories, except: :show
  resources :conversations, only: [:index, :show] do
    resources :messages, only: :create, controller: "conversation_messages"
  end
  resources :products, path: "/" do
    member do
      patch :feature
      patch :unfeature
    end
    resources :photos, only: :destroy, controller: "product_photos"
    resources :messages, only: :create, controller: "product_messages"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


=begin   todas estas routes hacen lo mismo que resources :products    resources :product contiene todas las rutas siguientes
delete "/products/:id", to: "products#destroy"
patch "/products/:id", to: "products#update"
post "/products", to: "products#create"
get "/products/new", to: "products#new", as: :new_product
get "/products", to: "products#index"
get "/products/:id", to: "products#show", as: :product 
get "/products/:id/edit", to: "products#edit", as: :edit_product
=end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
   get "up" => "rails/health#show", as: :rails_health_check  

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
