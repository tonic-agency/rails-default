Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to:  "website#home"

  devise_for :users
  
  get "/myaccount", to: "app#home", :as => "app_home"
  get "/kyc-info", to: "app#kyc_info", :as => "kyc_info"

  get "/start", to: "kyc_onboardings#start", :as => "start_kyc_onboarding"
  match "/get-started", to: "kyc_onboardings#new", :as => "new_kyc_onboarding", via: [:get,:post]
  get "/:kyc_onboarding_identifier/submit", to: "kyc_onboardings#submit", :as => "submit_kyc_onboarding"
  put "/get-started/summary", to: "kyc_onboardings#summary", :as => "kyc_onboarding_summary"

  get "/activity", to: "app#history"
  match "/add_funds", to: "add_funds#new", as: "add_funds", via: [:get,:post]
  post "/add_funds/validate_amount", to: "add_funds#validate_amount", as: "add_funds_validate_amount"
  post "/add_funds/validate_deposit_slip", to: "add_funds#validate_deposit_slip", as: "add_funds_validate_deposit_slip"
  get "/withdraw", to: "app#withdraw", as: "withdraw"
  match "/time_deposits/new", to: "time_deposits#new", as: "new_time_deposit", via: [:get,:post]
  post "/time_deposits/validate_time_deposit", to: "time_deposits#validate_time_deposit", as: "validate_time_deposit"
  get "/time_deposits/new/success", to: "time_deposits#success", as: "new_time_deposit_success"

  scope :modals do 
    get '(/:action)' => 'modals#:action', as: "modals"
  end

  namespace :mailers do
    get 'preview(/:action(/:id(.:format)))' => 'preview#:action'
  end

end
