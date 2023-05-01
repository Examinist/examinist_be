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

ActiveRecord::Schema.define(version: 2023_04_19_003123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "choices", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "choice"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_answer", default: false
    t.index ["question_id"], name: "index_choices_on_question_id"
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

  create_table "exam_templates", force: :cascade do |t|
    t.float "easy"
    t.float "medium"
    t.float "hard"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_exam_templates_on_course_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.string "faculty_name"
    t.string "university_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["faculty_id"], name: "index_staffs_on_faculty_id"
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

  add_foreign_key "choices", "questions"
  add_foreign_key "correct_answers", "choices"
  add_foreign_key "correct_answers", "questions"
  add_foreign_key "course_groups", "courses"
  add_foreign_key "courses", "faculties"
  add_foreign_key "exam_templates", "courses"
  add_foreign_key "question_types", "courses"
  add_foreign_key "questions", "courses"
  add_foreign_key "questions", "question_types"
  add_foreign_key "questions", "topics"
  add_foreign_key "staffs", "faculties"
  add_foreign_key "students", "faculties"
  add_foreign_key "topics", "courses"
end
