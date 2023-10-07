Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'pages#index'

  get '*pages/edit', to: 'pages#edit', as: 'edit_page'
  get '*pages/add', to: 'pages#new', as: 'new_page'
  get '*pages', to: 'pages#show', as: 'page'
  patch '*pages', to: 'pages#update', as: 'update_page'
  post '*pages', to: 'pages#create', as: 'create_page'
end
