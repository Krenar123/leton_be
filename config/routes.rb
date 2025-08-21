Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope module: :projects do
        resources :projects, param: :ref, only: [:index, :show, :create, :update] do
          get :objectives, to: "project_objectives#index"
          post :objectives, to: "project_objectives#create"
          patch "objectives/:ref", to: "project_objectives#update"
          delete "objectives/:ref", to: "project_objectives#destroy"

          get "objectives/:ref/tasks", to: "project_tasks#index"
          post "objectives/:ref/tasks", to: "project_tasks#create"
          patch "objectives/:ref/tasks/:task_ref", to: "project_tasks#update"
          delete "objectives/:ref/tasks/:task_ref", to: "project_tasks#destroy"

          get "item_lines", to: "project_item_lines#index"
          post "item_lines", to: "project_item_lines#create"
          patch "item_lines/:ref", to: "project_item_lines#update"
          delete "item_lines/:ref", to: "project_item_lines#destroy"
          post "item_lines/:ref/complete", to: "project_item_lines#complete"
        end
      end

      scope module: :clients do
        resources :clients, param: :ref, only: [:index, :show, :create, :update] do
          get :projects, to: "client_projects#index"
          get :invoices, to: "client_invoices#index"

          post :meetings, to: "client_meetings#create"
          get :meetings, to: "client_meetings#index"

          get    :notes,            to: "client_notes#index"
          post   :notes,            to: "client_notes#create"
          patch  "notes/:note_ref", to: "client_notes#update"
          delete "notes/:note_ref", to: "client_notes#destroy"
        end
      end
  
      scope module: :suppliers do
        resources :suppliers, param: :ref, only: [:index, :show, :create, :update] do
          get :projects, to: "supplier_projects#index"
          get :invoices, to: "supplier_invoices#index"
          get :bills,    to: "supplier_bills#index"
          get :meetings, to: "supplier_meetings#index"
        end
      end

      scope module: :users do
        resources :users, param: :ref, only: [:index, :show, :create, :update] do
          get :objectives, to: "user_objectives#index"
          get :tasks,      to: "user_tasks#index"
          get :meetings,   to: "user_meetings#index"
          get :wage_payments, to: "user_wage_payments#index"
          get :notes,      to: "user_notes#index"
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
