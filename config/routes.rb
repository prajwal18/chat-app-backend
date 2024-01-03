Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get 'up' => 'rails/health#show', as: :rails_health_check

  ## Auth Routes
  post 'auth/login', to: 'auth#login'
  post 'auth/forgot-password', to: 'auth#forgot_password'
  ## Auth Routes

  # User Routes
  get 'me', to: 'users#me'
  get 'users', to: 'users#list'
  post 'users', to: 'users#create'
  get 'users/:id', to: 'users#show'
  patch 'users/:id/change-password', to: 'users#change_password'
  # User Routes

  # Message routes
  get 'messages/conversation/:id', to: 'messages#conversation'
  post 'messages', to: 'messages#create'
  # Message routes

  # Otp routes
  post 'otp/get', to: 'otps#send_to_mail'
  post 'otp/verify-user', to: 'otps#verify_user'
  post 'otp/verify-otp', to: 'otps#verify_otp'
  # Otp routes
end
