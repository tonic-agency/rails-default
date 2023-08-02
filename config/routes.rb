Rails.application.routes.draw do
  root to: "site#index"

  get "/examples" => "site#examples", as: "examples"

  get "modal-content" => "site#modal_content", as: "modal_content"
  get "remote-content" => "site#remote_content", as: "remote_content"
  get "deferred-content" => "site#deferred_content", as: "deferred_content"
  get "dropdown-content" => "site#dropdown_content", as: "dropdown_content"
  get "toast-content" => "site#toast_content", as: "toast_content"

  match "/plain_remote_form" => "site#plain_remote_form", as: "plain_remote_form", via: [:get,:post]
  match "/remote_form" => "site#remote_form", as: "remote_form", via: [:get,:post]

end
