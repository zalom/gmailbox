Rails.application.routes.draw do
  root to: 'messages#index'
  devise_scope :user do
    get '/profile' => 'devise/registrations#edit', as: 'profile'
  end
  devise_for :users, path: '', controllers: { registrations: 'registrations' }

  resources :users do
    resources :messages, only: [:new, :create] #-> domain.com/users/:user_id/messages/new
  end
  resources :messages, only: [:index, :show, :destroy, :edit, :update] do #-> domain.com/messages/:id
    collection do
      patch :bulk_action
    end
  end
end
