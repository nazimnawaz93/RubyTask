Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'users/list'
  get 'users/index'
  root 'users#index'
  get 'users/changeStatus'
  post 'users/login'
  get 'users/market'
  get 'users/logout'
  get 'users/signup'
  post 'users/createUser'



end
