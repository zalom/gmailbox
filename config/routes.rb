Rails.application.routes.draw do
  root to: 'messages#index'
  devise_for :users, path: "", controllers: { registrations: 'registrations' }
  resources :users do
    get :profile
    resources :messages, only: [:new, :create] do #-> domain.com/users/:user_id/messages/new
      resources :trash_messages, only: :create    #-> domain.com/users/:user_id/messages/:message_id/trash_messages
    end
  end
  resources :messages, only: [:index, :show, :destroy] #-> domain.com/messages/:id
end
