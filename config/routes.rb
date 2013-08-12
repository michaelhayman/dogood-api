DoGoodApp::Application.routes.draw do
  devise_for :users, :controllers => {
      :sessions => 'sessions',
      :registrations => 'registrations',
      :passwords => 'passwords'
  }

  get "category/index"

  resources :goods

  root to: 'goods#index', :defaults => { :format => :json }
end
