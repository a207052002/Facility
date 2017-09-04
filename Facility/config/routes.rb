Rails.application.routes.draw do
  resources :facilities
  post '/facilities/:id/rent' => "rents#new"
  put '/facilities/:id/rent/:rent_id' =>  "rents#update"
  delete '/facilities/:id/rent/:rent_id' => "rents#destroy"
  get '/facilities/:id/rent/:rent_id' => "rents#controllpane"
  get '/facilities/:id/rent' => "rents#info"
  get '/facilities/:id/table' => "facilities#table"
  get '/facilities/:id/edit/more' => "facilities#more"
  put '/facilities/:id/edit/more' => "facilities#more_edit"
  delete '/facilities/:id/edit/more' => "facilities#more_delete"
  get '/facilities/:id/edit/table' => "facilities#edit_table"

  match 'auth/ncu_portal_open_id/callback', to: 'sessions#create', via: [:get, :post]
  get 'login' => "sessions#login"
  get 'logout' => "sessions#logout"

end
