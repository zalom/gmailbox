Rails.application.routes.draw do
  root to: 'messages#index'
  devise_for :users, path: "", controllers: { registrations: 'registrations' }
end
