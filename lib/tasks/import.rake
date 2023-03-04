
namespace :import do
  desc "Create 5 faculties"
  task faculties: :environment do
    FactoryBot.create_list(:faculty, 5)
  end

  desc "Create 10 students for each faculty"
  task students: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:student, 10, faculty: faculty)
    end
  end

  desc "Create 10 staffs for each faculty"
  task staffs: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:staff, 10, faculty: faculty)
    end
  end

  desc "Run all tasks"
  task all: %i[environment faculties students staffs]
end