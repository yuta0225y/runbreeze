FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    # プロフィール画像をオプションとする
    trait :with_profile_image do
      profile_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/profile_image.png'), 'image/png') }
    end
  end
end
