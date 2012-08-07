namespace :db do
  task :add_moderator => :environment do
    staff = ["a@staff.com", "b@staff.com", "c@staff.com"]
    staff.each do |mail|
      props = {
        email: mail,
        password: "123456",
        role: 2
      }
      user = User.create! props
    end
    mod = {
      email: "moderator@moderator.com",
      password: "123456",
      role: 1
      }
    moderator = User.create! mod
  end
end

