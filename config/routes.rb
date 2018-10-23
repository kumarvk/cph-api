Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :flights do
      resources :arrivals, only: [:index] do
        collection do
          get :search 
        end
      end
        
      resources :departures, only: [:index] do
        collection do
          get :search 
        end
      end
    end
  end
end
