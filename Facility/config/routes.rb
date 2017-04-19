Rails.application.routes.draw do
  resources :facilities
  post '/facilities/:id/rent' => "rent#new"
  put '/facilities/:id/rent' =>  "rent#update"

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
