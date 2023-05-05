Rails.application.routes.draw do
  get 'appointments/index'
  get 'appointments/add_details'
  get 'appointments/congrats'
  get 'appointments/select_slot'
  get 'appointments/slots'
  get 'appointments_booked/my_appointments'
  get 'appointments_booked/appointments_login'
  get 'appointments_booked/cancel'
  get 'appointments_booked/generate_invoice'
  get 'appointments_booked/create_session'
  
  resources :doctors
  resources :appointments
  resources :appointments_booked
  root 'doctors#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
