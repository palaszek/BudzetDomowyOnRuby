Rails.application.routes.draw do
  root to: 'public#home'

  resources :public
    resources :wallets do
      member do
        patch 'confirm'
        get :generate_pdf
      end
    resources :incomes
    resources :spendings
    end

  devise_for :users, controllers:
    {
      sessions: 'user/sessions',
      registrations: 'user/registrations'
    }
  devise_scope :user do
    put "/user/invitation", :to => "devise/invitations#update"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
