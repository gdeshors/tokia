namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Guillaume",
                 email: "a@a.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    5.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
