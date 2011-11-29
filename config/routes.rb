Kanbfire::Application.routes.draw do
  resources :project_mappings

  match 'auth/open_id/callback' => 'sessions#create'
  match 'auth/failure' => 'sessions#new'

  logged_in = lambda do |request|
    ApplicationController.signed_in? request
  end

  constraints logged_in do
    root :to => 'dashboards#show'
  end

  root :to => 'sessions#new'
end
