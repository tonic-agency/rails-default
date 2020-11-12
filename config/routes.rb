Rails.application.routes.draw do
  root to: "site#index"
  get "/editmode-examples" => "site#editmode_examples", :as => "editmode_examples"
  get "/tailwind-examples" => "site#tailwind_examples", :as => "tailwind_examples"
end
