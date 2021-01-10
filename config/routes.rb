Rails.application.routes.draw do
  root to: 'tasks#index'
  get 'tasks/index'
  get 'tasks/show'
  get 'tasks/new'
  get 'tasks', to: 'tasks#index'
  post 'tasks', to: 'tasks#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
