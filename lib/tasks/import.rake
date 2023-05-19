
namespace :import do
  desc "Create 1 university"
  task university: :environment do
    FactoryBot.create(:university, name: "Alexandria University")
    p 'University are created'
  end

  desc "Create 1 coordinator"
  task coordinator: :environment do
    FactoryBot.create(:coordinator, university: University.first)
    p 'Coordinator are created'
  end

  desc "Create 20 labs"
  task labs: :environment do
    FactoryBot.create_list(:lab, 20, university: University.first)
    p 'labs are created'
  end

  desc "Create 5 faculties"
  task faculties: :environment do
    Faculties::Faculties[0..4].each do |faculty|
      FactoryBot.create(:faculty, faculty_name: faculty[:name], university: University.first)
    end
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

  desc "Add 1 Questions of each type to each course"
  task questions: :environment do
    Faculty.all.each do |faculty|
      Course.where(faculty: faculty).each do |course|
        FactoryBot.create(:question, :with_mcq, course: course)
        FactoryBot.create(:question, :with_t_f, course: course)
        FactoryBot.create(:question, :with_essay, course: course)
        FactoryBot.create(:question, :with_short_answer, course: course)
      end
    end
    p 'One Question for each type is added for each course'
  end

  desc "Create 1 admin for each faculty"
  task admins: :environment do
    Faculty.all.each do |faculty|
      FactoryBot.create(:staff, faculty: faculty, role: :admin)
    end
    p 'Admins for each faculty are created'
  end

  desc "Run all tasks"
  task all: %i[environment university coordinator labs faculties students staffs courses course_topics course_groups course_group_students course_group_staffs questions admins]
end
