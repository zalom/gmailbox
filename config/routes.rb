Rails.application.routes.draw do
  root to: 'messages#index'
  devise_for :users, path: '', controllers: { registrations: 'registrations' }
  resources :users do
    get :profile
    resources :messages, only: [:new, :create] #-> domain.com/users/:user_id/messages/new
  end
  resources :messages, only: [:index, :show, :destroy, :edit, :update] #-> domain.com/messages/:id
end
