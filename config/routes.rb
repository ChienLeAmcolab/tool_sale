Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'
  resources :home
  resources :channel_setting do
    collection do
      get 'toggle_apply_render'
      get 'show_progress'
      get 'reset_progress'
    end
  end
  resources :job do
    collection do
      delete :destroy_all
    end
  end
end
