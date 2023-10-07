Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'pages#index'

  get '*pages/edit', to: 'pages#edit'
  get '*pages', to: 'pages#show'
  patch '*pages', to: 'pages#update'
end
