
namespace :import do
  desc "Create 5 faculties"
  task faculties: :environment do
    FactoryBot.create_list(:faculty, 5)
    p 'Faculties  are created'
  end

  desc "Create 50 students for each faculty"
  task students: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:student, 50, faculty: faculty)
    end
    p 'Students for each faculty are created'
  end

  desc "Create 10 instructors for each faculty"
  task staffs: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:staff, 10, faculty: faculty, role: :instructor)
    end
    p 'Instructors for each faculty are created'
  end

  desc "Create 5 courses for each faculty"
  task courses: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create_list(:course, 5, faculty: faculty)
    end
    p 'Courses for each faculty are created'
  end

  desc "Create 1 topics for each course"
  task course_topics: :environment do
    Course.all.each do |course|
      FactoryBot.create_list(:topic, 1, course: course)
    end
    p 'Topics for each course are created'
  end

  desc "Create 2 groups for each course"
  task course_groups: :environment do
    Course.all.each do |course|
      FactoryBot.create_list(:course_group, 2, course: course)
    end
    p 'Course Groups for each course are created'
  end

  desc "Add 25 students to each course group"
  task course_group_students: :environment do
    Course.all.each do |course|
      students_count = 0
      CourseGroup.where(course: course).each do |group|
        Student.where(faculty: course.faculty).offset(students_count).limit(25).each do |student|
          CourseGroupStudent.create!(student: student, course_group: group)
        end
        students_count += 25
      end
    end
    p 'Students for each course groups are added'
  end

  desc "Add 1 Instructor to each course group"
  task course_group_staffs: :environment do
    Faculty.all.each do |faculty|
      staffs_count = 0
      Course.where(faculty: faculty).each do |course|
        CourseGroup.where(course: course).each do |group|
          Staff.where(faculty: course.faculty).offset(staffs_count).limit(1).each do |staff|
            CourseGroupStaff.create!(staff: staff, course_group: group)
          end
          staffs_count += 1
        end
      end
    end
    p 'Instructors for each course groups are added'
  end

  desc "Run all tasks"
  task all: %i[environment faculties students staffs courses course_topics course_groups course_group_students course_group_staffs]
end