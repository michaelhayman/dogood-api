DoGoodApp::Application.routes.draw do
  devise_for :users, :controllers => {
      :sessions => 'sessions',
      :registrations => 'registrations',
      :passwords => 'passwords'
  }

  resources :users, :only => [ :show ] do
    collection do
      get :regooders
      get :likers
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
    end
    member do
      get :points
      get :status
      get :rank
    end
  end

  resources :tags, :only => [ :index ] do
    collection do
      get :search
      get :popular
    end
  end

  resources :reports, :only => [ :create ]

  resources :categories, :only => [ :index ]

  # get "category/index"

  resources :goods, :only => [ :index, :show, :create ] do
    collection do
      get :posted_or_followed_by
      get :nominations
      get :liked_by
      get :tagged
      get :popular
      get :nearby
    end
  end

  resources :comments, :only => [ :index, :create ]

  resources :votes, :only => [ :create, :destroy ]

  resources :follows, :only => [ :create, :destroy ]

  resources :rewards, :only => [ :index, :create, :destroy ] do
    collection do
      post :claim
      get :claimed
      get :highlights
    end
  end

  root to: 'goods#index', :defaults => { :format => :html }
end
