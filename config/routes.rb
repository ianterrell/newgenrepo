AppTemplate::Application.routes.draw do
  post "/auth/:provider/callback" => "sessions#create"
  post "/auth/signout" => "sessions#destroy"
  match "/auth/failure", to: "sessions#failure"

  namespace :api do
    
    
    namespace :v1 do
      
        resources :stores
      
        resources :categories
      
        resources :products
      
        resources :incoming_contacts
      
        resources :sales_reports
      
        resources :users
      
        resources :orders
      
        resources :dogs
      
        resources :chameleons
      
    end # v1
  end
end
