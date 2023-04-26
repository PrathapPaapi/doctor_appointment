Rails.application.routes.draw do
  get 'appointments/index'
  get 'appointments/add_details'
  get 'appointments/congrats'
  get 'appointments/select_slot'
  get 'appointments/my_appointments'
  get 'appointments/slots'
  
  resources :doctors
  resources :appointments
  root 'doctors#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
