Rails.application.routes.draw do
  root to: 'messages#index'
  devise_for :users, path: '', controllers: { registrations: 'registrations' }
  resources :users do
    get :profile
    resources :messages, only: [:new, :create, :edit] #-> domain.com/users/:user_id/messages/new
  end
  resources :messages, only: [:index, :show, :destroy] #-> domain.com/messages/:id
end
