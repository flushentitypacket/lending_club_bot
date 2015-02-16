FactoryGirl.define do
  factory :loan do
    sequence(:id) { |n| n }
    json do
      { id: id }
    end
  end
end
