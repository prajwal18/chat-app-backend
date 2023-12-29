Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  ## Auth Routes
  post 'auth/login', to: 'auth#login'
  post 'auth/signup', to: 'user#create'
  ## Auth Routes

  # User Routes
  get 'me', to: 'users#me'
  get 'users', to: 'users#list'
  get 'users/:id', to: 'users#show'
  post 'users/:id', to: 'users#show'
  # User Routes

  # Message routes
  get 'messages/conversation/:id', to: 'messages#conversation'
  post 'messages', to: 'messages#create'
  # Message routes

  # Otp routes
  post 'otp/get', to: 'otps#send_to_mail'
  post 'otp/verify', to: 'otps#verify'
  # Otp routes
end
