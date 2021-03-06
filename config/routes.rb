DoGoodApp::Application.routes.draw do
  devise_for :users, controllers: {
      :sessions => 'sessions',
      :registrations => 'registrations',
      :passwords => 'passwords'
  }

  resources :users, only: [ :show ] do
    collection do
      get :voters
      get :followers
      get :following
      put :update_profile
      put :update_password
      post :validate_name
      delete :remove_avatar
      get :search
      get :search_by_emails
      get :search_by_twitter_ids
      get :search_by_facebook_ids
      post :social
      get :points
      get :reset_password
    end
    member do
      get :status
      get :rank

      get :nominations_for
      get :followed_by
      get :voted_by
      get :nominations_by
      get :help_wanted_by
    end
  end

  resources :tags, only: [ :index ] do
    collection do
      get :search
      get :popular
    end
  end

  resources :reports, only: [ :create ]

  resources :categories, only: [ :index, :show ]

  resources :goods do
    collection do
      get :nominations_for
      get :followed_by
      get :voted_by
      get :nominations_by
      get :help_wanted_by
      get :tagged
      get :popular
      get :nearby
    end
  end

  resources :comments, only: [ :index, :create ]

  resources :votes, only: [ :create, :destroy ]

  resources :follows, only: [ :create, :destroy ]

  resources :rewards, only: [ :index, :create, :destroy ] do
    collection do
      post :claim
      get :claimed
      get :highlights
    end
  end

  post 'unsubscribe_email', to: 'unsubscribes#opt_out'

  resources :devices, only: [ :update, :destroy ]

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#exception'

  get 'goods/tagged/:name', to: 'goods#tagged', as: :tagged_good_list
  get 'privacy', to: 'home#privacy'
  get '/terms.html', to: 'home#terms'
  root to: 'home#index'
end
