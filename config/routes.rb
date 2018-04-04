Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
  get 'about' => 'pages#about'
  get 'result' => 'pages#result'
  get 'search' => 'pages#search'
  #resources :posts
end
