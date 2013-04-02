ShopChallenge::Application.routes.draw do
  resources :products, only: %w(show index) do
    match 'search', on: :collection
    get 'cat/:category_id', to: 'products#index', on: :collection, as: 'category'
  end

  root to: 'products#index'
end
