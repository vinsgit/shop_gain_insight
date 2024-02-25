# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :passwords]

  root 'home#index'

  post '/set_current_shop' => 'home#set_current_shop', as: :set_current_shop

  resources :shops, only: [:new, :edit, :index, :create, :update]
  resources :investors, only: [:new, :edit, :index, :create, :update] do
    collection do
      delete :remove
    end
  end
  resources :skus, :shipments, :procurements, :item_links, only: [:new, :edit, :index, :create, :update] do
    collection do
      delete :remove
    end
  end
end
