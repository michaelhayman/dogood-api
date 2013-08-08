DoGoodApp::Application.routes.draw do
  get "category/index"
  devise_for :users

  resources :goods
  root to: 'goods#index'

  resources :users
end
