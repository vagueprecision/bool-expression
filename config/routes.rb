Rails.application.routes.draw do
  root 'expressions#index'

  resources :expressions
  post 'expressions/validate' => 'expressions#validate'
  post 'expressions/evaluate' => 'expressions#evaluate'
end
