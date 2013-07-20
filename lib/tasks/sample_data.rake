namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    user = User.create_from_omniauth({provider: 'developer', uid: 'testuser1', info: {name: 'Test User 1', email: 'testuser1@example.com'}})
    user.tables.create!(name: "Test Table 1",  data_source: nil, data: "[[1],[2]]")
  end
end
