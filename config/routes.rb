Rails.application.routes.draw do
  root to: "site#index"

  get "modal-content" => "site#modal_content", as: "modal_content"
end
