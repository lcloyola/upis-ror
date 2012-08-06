namespace :db do
  task :accounts => :environment do
    faculties = Faculty.all
    faculties.each do |f|
      mail = f.email
      mail = "#{f.id}@temporary.com" if mail == ''
      props = {
        email: mail,
        password: "123456"
      }
      user = User.create! props
      f.update_attributes(:user_id => user.id)
    end
  end
end

