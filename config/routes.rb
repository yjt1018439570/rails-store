Rails.application.routes.draw do
  root 'products#index'
  get 'login/secret', to: 'login#secret', as: 'secret'
  get '/login', to: 'login#index', as: 'login'
  get 'cart', to: 'orders#cart', as: 'cart'
  post 'checkout', to: 'orders#checkout', as: 'checkout'
  get 'orders/:id', to: 'orders#show', as: 'order'
  patch '/update_cart', to: 'orders#update_cart', as: 'update_cart'
  delete '/remove_item_from_cart/:item_id', to: 'orders#remove_item_from_cart', as: 'remove_item_from_cart'
  #get 'remove_item/:item_id' => 'orders#remove_item_from_cart', as: :remove_item_from_cart
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :new, :create] do
    resource :profile, only: [:show, :edit, :update]
  end
  resources :products, only: [:index, :show]
  resources :orders, only: [:index, :show, :create] do
    member do
      delete :delete, action: :destroy, as: :delete
    end
  end
end
