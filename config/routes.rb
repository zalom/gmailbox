Rails.application.routes.draw do
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  devise_for :users, controllers: { registrations: 'registrations' }
  resource :profile, only: [:show, :edit, :update]
end
