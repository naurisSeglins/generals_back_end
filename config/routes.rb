require "sidekiq/web"

Rails.application.routes.draw do
  # mounts the Sidekiq web UI dashboard at the /sidekiq path in your Rails application
  # Real-time statistics about your job queues
  # Information about currently running, completed, and failed jobs
  # The ability to retry failed jobs
  # Queue management capabilities
  mount Sidekiq::Web => "/sidekiq"

  resources :unit

  get "unit/index", to: "unit#index"
  post "unit/create", to: "unit#create"
  get "unit/:id", to: "unit#show"
  put "unit/update/:id", to: "unit#update"
  get "unit/destroy/:id", to: "unit#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
