Rails.application.routes.draw do
  root to: "site#show_docs_page"

  get "modal-content" => "site#modal_content", as: "modal_content"

  get "/docs/:file" => "site#show_docs_page", as: "docs"
end
