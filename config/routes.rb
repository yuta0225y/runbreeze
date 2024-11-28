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

  resources :posts do
    resources :comments, only: %i[create], shallow: true
    collection do
      get :bookmarked_posts
    end

    resources :likes, only: %i[create destroy], shallow: true
  end

  resources :tags, only: [] do
    collection do
      get :by_category
    end
  end

  resources :bookmarks, only: %i[create destroy index]
  resources :likes, only: %i[index]
  
  # Health check ルート（アップタイムモニタリング用）
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA サポート用の動的ルート
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
