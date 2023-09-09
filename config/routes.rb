Rails.application.routes.draw do
  root to: "site#show_docs_page"

  devise_for :users

  get "/examples" => "site#examples", as: "examples"

  get "modal-content"     => "htmx_demo#modal_content"      , as: "modal_content"
  get "remote-content"    => "htmx_demo#remote_content"     , as: "remote_content"
  get "deferred-content"  => "htmx_demo#deferred_content"   , as: "deferred_content"
  get "dropdown-content"  => "htmx_demo#dropdown_content"   , as: "dropdown_content"
  get "toast-content"     => "htmx_demo#toast_content"      , as: "toast_content"

  match "/plain_remote_form" => "site#plain_remote_form", as: "plain_remote_form", via: [:get,:post]
  match "/remote_form" => "site#remote_form", as: "remote_form", via: [:get,:post]

  match "/minijs" => "site#minijs", via: [:get,:post]
  match "/taylher_demo" => "site#taylher_demo", via: [:get]

  get "/docs/:file" => "site#show_docs_page", as: "docs"
  get "/examples/:file" => "site#show_example", as: "example"

end
