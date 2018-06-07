Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
  get 'about' => 'pages#about'
  get 'result' => 'pages#result'
  get 'search' => 'pages#search'
  get 'test' => 'pages#test'
  get 'profile' => 'pages#profile'
  post 'add' => 'pages#add'
  post 'add_to_db' => 'pages#add_to_db'
  post 'remove_from_db' => 'pages#remove_from_db'
  #resources :posts
end
