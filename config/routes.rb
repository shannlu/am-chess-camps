Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  root 'home#index'

  # Routes for main resources
  resources :camps
  resources :instructors
  resources :locations
  resources :curriculums
  resources :users
  resources :sessions
  resources :families
  resources :registrations
  resources :students

  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor

  get 'camps/:id/students', to: 'camps#students', as: :camp_students

  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  get 'user/dashboard' => 'users#dashboard'

  get 'cart/add' => 'registrations#add'
  get 'cart/remove' => 'registrations#remove'
  get 'cart/update' => 'registrations#update'
  get 'cart/empty' => 'registrations#empty'
  get 'cart/checkout' => 'registrations#checkout'
  post 'registrations/place'
  get 'cart' => 'registrations#cart', as: :cart

  get 'confirmation' => 'registrations#confirmation', :as => :confirmation
  get 'registrations/cancel'


end
