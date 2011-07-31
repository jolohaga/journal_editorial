Journal::Application.routes.draw do
  root :to => "dashboard#index"
  
  devise_for :users, :path => :sessions, :path_names => {:signup => :register}
  #devise_scope :user do
  #  get '/signin' => 'devise/sessions#new', :as => :signin
  #  post '/signin' => 'devise/sessions#create', :as => :authenticate
  #  get '/signup' => 'devise/registrations', :action => 'new', :as => :signup
  #  get '/signout' => 'devise/sessions#destroy'
  #  get '/register' => 'devise/registrations', :action => 'new'
  #end
  resources :specializations
  resources :correspondences
  match '/correspondences/:id/hide' => 'correspondences#hide', :as => :hide
  match '/unhide/:id' => 'correspondences#unhide', :as => :unhide
  match '/hidden_correspondences' => 'correspondences#hidden_correspondences', :as => :hidden_correspondences
  
  resources :submissions do
    resources :assignments, :shallow => true
    resources :associates, :only => [:new, :create]
    #resources :editors, :only => [:new,:create]
    #resources :notifications, :only => [:index,:show] do
    #  post :submit
    #end
    resources :comments, :shallow => true
    resources :states, :shallow => true do
      resources :comments, :shallow => true
    end
    resources :folders, :shallow => true do
      resources :documents, :shallow => true do
        resources :comments, :shallow => true
      end
      resources :comments, :shallow => true
      member do
        post :upload, :as => :upload_documents
        get :download
      end
    end
    member do
      post :revert_state
      get :adopt
    end
    collection do
      get :search
    end
  end
  get '/submissions/:submission_id/notifications' => 'notifications#index', :as => :submission_notifications
  get '/submissions/:submission_id/notifications/:id' => 'notifications#show', :as => :submission_notification
  post '/submissions/:submission_id/notifications/:id/submit' => 'notifications#submit', :as => :submission_notification_submit
  get '/folders/:folder_id/notifications' => 'notifications#index', :as => :folder_notifications
  get '/folders/:folder_id/notifications/:id' => 'notifications#show', :as => :folder_notification
  post '/folders/:folder_id/notifications/:id/submit' => 'notifications#submit', :as => :folder_notification_submit
  resources :users do
    member do
      post :assign_role
    end
  end
  get '/users/:id/roles/:role_id/unassign' => 'users#unassign_role', :as => :unassign_role
  resources :roles
  resources :form_letters do
    resources :tags, :only => [:create,:destroy], :shallow => true
  end
  resources :associates, :only => [:index,:show,:new,:create,:edit,:update]
  resources :editors, :only => [:index,:show,:new,:create,:edit,:update] do
    resources :expertise, :only => [:index,:create,:destroy]
    collection do
      get :search
    end
  end
    
  match '/download_attachment/:id' => 'attachments#download', :as => :download_attachment
  
  get '/activity/:submission' => 'submissions#activity', :as => :activity_on
  get '/activity' => 'submissions#activity'
  #get '/outstanding' => 'submissions#outstanding'
end