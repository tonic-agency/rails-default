Rails.application.routes.draw do
  root to: "site#html_first_home"

  devise_for :users

  get "/og-image" => "site#open_graph_image", :as => "og_image"

  get "/examples" => "site#examples", as: "examples"
  get "/libraries" => "site#libraries", as: "libraries"
  get "/snippets" => "site#snippets", as: "snippets"
  get "/components" => "site#components", as: "components"

  get "modal-content"     => "htmx_demo#modal_content"      , as: "modal_content"
  get "remote-content"    => "htmx_demo#remote_content"     , as: "remote_content"
  get "deferred-content"  => "htmx_demo#deferred_content"   , as: "deferred_content"
  get "dropdown-content"  => "htmx_demo#dropdown_content"   , as: "dropdown_content"
  get "toast-content"     => "htmx_demo#toast_content"      , as: "toast_content"

  match "/plain_remote_form" => "site#plain_remote_form", as: "plain_remote_form", via: [:get,:post]
  match "/remote_form" => "site#remote_form", as: "remote_form", via: [:get,:post]

  match "/minijs" => "site#minijs", via: [:get,:post]
  get "/minijs-two" => "minijs#home"
  # match "/taylher_demo" => "site#taylher_demo", via: [:get]

  get "/docs/:file" => "site#show_docs_page", as: "docs"
  get "/snippets/:file" => "site#show_snippet", as: "snippet"

end
