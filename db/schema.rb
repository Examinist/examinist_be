# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_06_27_122130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "busy_labs", force: :cascade do |t|
    t.bigint "lab_id", null: false
    t.bigint "exam_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "staff_id"
    t.index ["exam_id"], name: "index_busy_labs_on_exam_id"
    t.index ["lab_id"], name: "index_busy_labs_on_lab_id"
    t.index ["staff_id"], name: "index_busy_labs_on_staff_id"
  end

  create_table "choices", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "choice"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_answer", default: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "coordinators", force: :cascade do |t|
    t.string "username"
    t.bigint "university_id", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "token_version", default: 0
    t.index ["university_id"], name: "index_coordinators_on_university_id"
  end

  create_table "correct_answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "choice_id"
    t.index ["choice_id"], name: "index_correct_answers_on_choice_id"
    t.index ["question_id"], name: "index_correct_answers_on_question_id"
  end

  create_table "course_group_staffs", force: :cascade do |t|
    t.bigint "course_group_id"
    t.bigint "staff_id"
    t.index ["course_group_id"], name: "index_course_group_staffs_on_course_group_id"
    t.index ["staff_id"], name: "index_course_group_staffs_on_staff_id"
  end

  create_table "course_group_students", force: :cascade do |t|
    t.bigint "course_group_id"
    t.bigint "student_id"
    t.index ["course_group_id"], name: "index_course_group_students_on_course_group_id"
    t.index ["student_id"], name: "index_course_group_students_on_student_id"
  end

  create_table "course_groups", force: :cascade do |t|
    t.string "name"
    t.bigint "course_id", null: false
    t.datetime "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_groups_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.bigint "faculty_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "credit_hours"
    t.index ["faculty_id"], name: "index_courses_on_faculty_id"
  end

  create_table "exam_questions", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "question_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exam_id", "question_id"], name: "index_exam_questions_on_exam_id_and_question_id", unique: true
    t.index ["exam_id"], name: "index_exam_questions_on_exam_id"
    t.index ["question_id"], name: "index_exam_questions_on_question_id"
  end

  create_table "exam_templates", force: :cascade do |t|
    t.float "easy", default: 60.0
    t.float "medium", default: 30.0
    t.float "hard", default: 10.0
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_exam_templates_on_course_id"
  end

  create_table "exams", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "staff_id", null: false
    t.string "title"
    t.datetime "starts_at"
    t.integer "duration"
    t.integer "total_score"
    t.integer "status"
    t.boolean "is_auto", default: false
    t.boolean "has_models", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "schedule_id"
    t.datetime "ends_at"
    t.index ["course_id"], name: "index_exams_on_course_id"
    t.index ["schedule_id"], name: "index_exams_on_schedule_id"
    t.index ["staff_id"], name: "index_exams_on_staff_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.string "faculty_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "university_id", null: false
    t.index ["university_id"], name: "index_faculties_on_university_id"
  end

  create_table "labs", force: :cascade do |t|
    t.string "name"
    t.integer "capacity"
    t.bigint "university_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["university_id"], name: "index_labs_on_university_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "name"
    t.integer "easy_weight", default: 1
    t.integer "medium_weight", default: 2
    t.integer "hard_weight", default: 3
    t.float "ratio", default: 0.0
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_question_types_on_course_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "question_type_id"
    t.bigint "topic_id"
    t.bigint "course_id", null: false
    t.text "header"
    t.integer "difficulty"
    t.integer "answer_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_questions_on_course_id"
    t.index ["question_type_id"], name: "index_questions_on_question_type_id"
    t.index ["topic_id"], name: "index_questions_on_topic_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "faculty_id", null: false
    t.index ["faculty_id"], name: "index_schedules_on_faculty_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "must_change_password", default: true
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "faculty_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.bigint "token_version", default: 0
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["faculty_id"], name: "index_staffs_on_faculty_id"
  end

  create_table "student_answers", force: :cascade do |t|
    t.bigint "student_exam_id", null: false
    t.bigint "exam_question_id", null: false
    t.float "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "answer", default: [], array: true
    t.boolean "marked", default: false
    t.boolean "solved", default: false
    t.index ["exam_question_id"], name: "index_student_answers_on_exam_question_id"
    t.index ["student_exam_id"], name: "index_student_answers_on_student_exam_id"
  end

  create_table "student_exams", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "exam_id", null: false
    t.float "grade"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exam_id"], name: "index_student_exams_on_exam_id"
    t.index ["student_id"], name: "index_student_exams_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "must_change_password", default: true
    t.string "academic_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "faculty_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.bigint "token_version", default: 0
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["faculty_id"], name: "index_students_on_faculty_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_topics_on_course_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "busy_labs", "exams"
  add_foreign_key "busy_labs", "labs"
  add_foreign_key "busy_labs", "staffs"
  add_foreign_key "choices", "questions"
  add_foreign_key "coordinators", "universities"
  add_foreign_key "correct_answers", "choices"
  add_foreign_key "correct_answers", "questions"
  add_foreign_key "course_groups", "courses"
  add_foreign_key "courses", "faculties"
  add_foreign_key "exam_questions", "exams"
  add_foreign_key "exam_questions", "questions"
  add_foreign_key "exam_templates", "courses"
  add_foreign_key "exams", "courses"
  add_foreign_key "exams", "schedules"
  add_foreign_key "exams", "staffs"
  add_foreign_key "faculties", "universities"
  add_foreign_key "labs", "universities"
  add_foreign_key "question_types", "courses"
  add_foreign_key "questions", "courses"
  add_foreign_key "questions", "question_types"
  add_foreign_key "questions", "topics"
  add_foreign_key "schedules", "faculties"
  add_foreign_key "staffs", "faculties"
  add_foreign_key "student_answers", "exam_questions"
  add_foreign_key "student_answers", "student_exams"
  add_foreign_key "student_exams", "exams"
  add_foreign_key "student_exams", "students"
  add_foreign_key "students", "faculties"
  add_foreign_key "topics", "courses"
end
