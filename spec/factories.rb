FactoryGirl.define do
  factory :user do
    name      "Peter Alfvin"
    provider  'developer'
    uid       "peter@example.com"
  end

  factory :chart do
    data_source 'foo'
    name 'mychart'
    user
  end

  factory :dashboard do
    name "New Dashboard"
    user
  end

  factory :dashboard_element do
    dashboard
    chart
  end

end