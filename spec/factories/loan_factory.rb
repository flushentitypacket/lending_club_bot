FactoryGirl.define do
  factory :loan do
    to_create { |i| i.save }
    sequence(:id) { |n| n }
    json do
      { id: id }
    end
  end
end
