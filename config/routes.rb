Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'user/list'
  root 'user#index'
  get 'user/changeStatus'
  post 'user/login'
  get 'user/market'
  get 'user/logout'

end
