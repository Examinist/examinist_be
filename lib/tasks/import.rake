
namespace :import do
  desc "Create 5 faculties"
  task faculties: :environment do
    FactoryBot.create_list(:faculty, 5)
  end

  desc "Create 50 students for each faculty"
  task students: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:student, 50, faculty: faculty)
    end
  end

  desc "Create 10 staffs for each faculty"
  task staffs: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:staff, 10, faculty: faculty)
    end
  end

  desc "Create 5 courses for each faculty"
  task courses: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:course, 5, faculty: faculty)
    end
  end

  desc "Create 2 groups for each course"
  task course_groups: :environment do
    Course.all.each do |course|
      FactoryBot.create_list(:course_group, 2, course: course)
    end
  end

  desc "Add 25 students to each course group"
  task course_group_students: :environment do
    Course.all.each do |course|
      students_count = 0
      CourseGroup.where(course: course).each do |group|
        group.add_students(Student.where(faculty: course.faculty).offset(students_count).limit(25))
        students_count += 25
      end
    end
  end

  desc "Add 1 staff to each course group"
  task course_group_staffs: :environment do
    Course.all.each do |course|
      staffs_count = 0
      CourseGroup.where(course: course).each do |group|
        group.add_staffs(Staff.where(faculty: course.faculty).offset(staffs_count).limit(1))
        staffs_count += 1
      end
    end
  end

  desc "Run all tasks"
  task all: %i[environment faculties students staffs courses course_groups course_group_students course_group_staffs]
end