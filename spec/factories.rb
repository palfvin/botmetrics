FactoryGirl.define do
  factory :user do
    name      "Peter Alfvin"
    provider  'developer'
    uid       "peter@example.com"
  end

  factory :chart do
    data_source 'foo'
    user
  end

end