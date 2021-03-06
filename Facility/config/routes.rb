Rails.application.routes.draw do
  get '/facilities/print' => "facilities#appform"
  get '/facilities/mailverify' => "facilities#mail_verify"
  post '/facilities/mailverifyRequest' => "facilities#mail_verify_request"
  post '/facilities/telset' => "facilities#tel_set"
  get 'facilities/search' => "facilities#search"
  put 'facilities/notification' => "facilities#notify_switch"
  post '/facilities/:id/rent/queue' => "rents#queue"
  resources :facilities

  post '/facilities/:id/rent' => "rents#new"
  put 'facilities/:id/rent/cancel/:rent_id' => "rents#cancel"
  put '/facilities/:id/rent/:rent_id' =>  "rents#update"
  put '/facilities/:id/rent' =>  "rents#update"
  delete '/facilities/:id/rent/:rent_id' => "rents#destroy"
  get '/facilities/:id/rent/:rent_id' => "rents#controllpane"
  get '/facilities/:id/rent' => "rents#info"
  get '/facilities/:id/table' => "facilities#table"
  get '/facilities/:id/edit/more' => "facilities#more"
  put '/facilities/:id/edit/more' => "facilities#more_edit"
  delete '/facilities/:id/edit/more' => "facilities#more_delete"
  get '/facilities/:id/edit/table' => "facilities#edit_table"
  get '/instruction' => "facilities#instruction"


  match 'auth/ncu_portal_open_id/callback', to: 'sessions#create', via: [:get, :post]
  get 'login' => "sessions#login"
  get 'logout' => "sessions#logout"

end
