DoGoodApp::Application.routes.draw do
  devise_for :users, :controllers => {
      :sessions => 'sessions',
      :registrations => 'registrations',
      :passwords => 'passwords'
  }

  resources :users do
    collection do
      get :regooders
      get :likers
      get :followers
      get :following
    end
  end

  get "category/index"

  resources :goods, :only => [ :index, :show, :create ] do
    collection do
      get :posted_or_followed_by
      get :liked_by
    end
  end

  resources :comments, :only => [ :index, :create ]

  # sadly can't use crud here since we don't have an ID
  resources :votes, :only => [ :create ] do
    collection do
      post :remove
    end
  end

  resources :follows, :only => [ :create ] do
    collection do
      post :remove
    end
  end

  resources :rewards

  root to: 'goods#index', :defaults => { :format => :json }
end
