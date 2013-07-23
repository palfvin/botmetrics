FactoryGirl.define do
  factory :user do
    name      "Peter Alfvin"
    provider  'developer'
    uid       "palfvin@gmail.com"
  end

  factory :table do
    name   'foobar'
    user
  end

  factory :chart do
    name 'mychart'
    user
  end

  factory :dashboard do
    name "New Dashboard"
    description "Test Description"
    user
  end

  factory :dashboard_element do
    dashboard
    chart
  end

end
