DoGoodApp::Application.routes.draw do

  get "category/index"
  devise_for :users

  resources :goods

  root to: 'goods#index', :defaults => { :format => :json }

  resources :users
end
