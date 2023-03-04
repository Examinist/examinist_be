
namespace :import do
  desc "Create 5 faculties"
  task faculties: :environment do
    for counter in 1..5 do
      FactoryBot.create(:faculty)
    end
  end

  desc "Create 10 students for each faculty"
  task students: :environment do
    Faculty.all.each do |faculty|
      for counter in 1..10 do
        FactoryBot.create(:student, faculty: faculty)
      end
    end
  end

  desc "Create 10 staffs for each faculty"
  task staffs: :environment do
    Faculty.all.each do |faculty|
      for counter in 1..10 do
        FactoryBot.create(:staff, faculty: faculty)
      end
    end
  end

  desc "Run all tasks"
  task all: %i[environment faculties students staffs]
end