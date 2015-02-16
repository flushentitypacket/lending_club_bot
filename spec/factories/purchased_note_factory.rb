FactoryGirl.define do
  factory :purchased_note do
    to_create { |i| i.save }
    purchased_at Time.now
    association :loan
  end
end
