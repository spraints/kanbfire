Kanbfire::Application.routes.draw do
  match 'auth/open_id/callback' => 'sessions#create'
  match 'auth/failure' => 'sessions#new'

  logged_in = lambda do |request|
    ApplicationController.signed_in? request
  end

  constraints logged_in do
    root :to => 'dashboards#show'
    resources :project_mappings
    match 'todo/:id' => 'todo#todo', :as => :new_campfire_message_test
  end

  root :to => 'sessions#new'
  match '/update/:token' => 'kanbanery_updates#create', :as => :kanbanery
end
