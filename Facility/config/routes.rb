Rails.application.routes.draw do
  resources :facilities
  post '/facilities/:id/rent' => "rent#new"
  put '/facilities/:id/rent' =>  "rent#update"
  delete '/facilities/:id/rent' => "rent#destory"

  match 'auth/ncu_portal_open_id/callback', to: 'sessions#create', via: [:get, :post]
  get 'login' => "sessions#login"
  get 'logout' => "sessions#logout"

end
