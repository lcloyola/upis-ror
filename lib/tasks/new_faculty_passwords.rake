namespace :db do
  task :new_faculty_passwords => :environment do
   faculties = Faculty.all
    faculties.each do |f|
      unless f.user.nil?
        f.user.update_attributes(:password => Devise.friendly_token.first(6).downcase)
        puts "Faculty: #{f.fullname}"
        puts "Username: #{f.user.email}"
        puts "Password: #{f.user.password}"
        puts ""
      end
    end
  end
end

