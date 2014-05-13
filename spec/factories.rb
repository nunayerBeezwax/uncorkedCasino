FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "123455678"
    password_confirmation { |u| u.password }
  end

  factory :api_key do
    access_token "fherohgre08gh09"
  end
   factory :game do
    name "blackjack"
    rules "Get 21"
  end
end