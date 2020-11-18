if Rails.env == "production"
  # same_site: :none, secure: true - нужно для правильной работы куки
  Rails.application.config.session_store :cookie_store, key: "_prod_todo_api", domain: "https://todo-rubygarage-api.herokuapp.com", same_site: :none, secure: true
else
  Rails.application.config.session_store :cookie_store, key: "_dev_todo_api"
end