Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/feed', to: 'api#client'
  get '/browser', to: 'api#browser'
  root :to => 'root#index'
end
