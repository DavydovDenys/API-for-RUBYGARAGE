Rails.application.routes.draw do
  resources :project  do
    resources :tasks
  end


  root to: 'static#home'
end
