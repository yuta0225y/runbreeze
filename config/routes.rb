Rails.application.routes.draw do
  root "static_pages#top"

  devise_for :users,
             path: "",
             path_names: {
               sign_up: "",
               sign_in: "login",
               sign_out: "logout",
               registration: "signup"
             },
             controllers: {
               registrations: "users/registrations",
               sessions: "users/sessions"
             }

  resources :posts, only: %i[index new create]
  resources :tags, only: %i[] do
    collection do
      get :by_category, to: "tags#by_category"
    end
  end

  # Health check ルート（アップタイムモニタリング用）
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA サポート用の動的ルート
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
