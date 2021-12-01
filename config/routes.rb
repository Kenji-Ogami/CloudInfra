Rails.application.routes.draw do
  root 'instances#index'
  get 'ip_addresses/new'
  get 'instances/new'
  get 'machines/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources 'ip_addresses'
  resources 'instances'
  resources 'machines'
end
