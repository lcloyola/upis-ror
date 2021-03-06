# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150206070131) do

  create_table "batches", :force => true do |t|
    t.integer  "year"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "faculty_id"
    t.integer  "schoolyear_id"
    t.integer  "sem"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "yearlong",      :default => true
    t.integer  "is_locked",     :default => 0
  end

  add_index "courses", ["faculty_id"], :name => "index_courses_on_faculty_id"
  add_index "courses", ["schoolyear_id"], :name => "index_courses_on_schoolyear_id"
  add_index "courses", ["section_id"], :name => "index_courses_on_section_id"
  add_index "courses", ["subject_id"], :name => "index_courses_on_subject_id"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollees", :force => true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.integer  "quartera"
    t.integer  "quarterb"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollees", ["course_id", "student_id"], :name => "index_enrollees_on_course_id_and_student_id", :unique => true
  add_index "enrollees", ["course_id"], :name => "index_enrollees_on_course_id"
  add_index "enrollees", ["student_id"], :name => "index_enrollees_on_student_id"

  create_table "faculties", :force => true do |t|
    t.string   "last"
    t.string   "given"
    t.string   "middle"
    t.integer  "department_id"
    t.date     "appointment"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthday"
    t.string   "landline"
    t.integer  "user_id"
  end

  add_index "faculties", ["department_id"], :name => "index_faculties_on_department_id"
  add_index "faculties", ["user_id"], :name => "index_faculties_on_user_id"

  create_table "grades", :force => true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.integer  "quarter"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  add_index "grades", ["course_id"], :name => "index_grades_on_course_id"
  add_index "grades", ["student_id"], :name => "index_grades_on_student_id"

  create_table "gwas", :force => true do |t|
    t.integer  "student_id"
    t.integer  "schoolyear_id"
    t.integer  "gwa_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "final",         :precision => 10, :scale => 5
    t.decimal  "raw",           :precision => 10, :scale => 5
  end

  add_index "gwas", ["schoolyear_id"], :name => "index_gwas_on_schoolyear_id"
  add_index "gwas", ["student_id"], :name => "index_gwas_on_student_id"

  create_table "members", :force => true do |t|
    t.integer  "section_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["section_id"], :name => "index_members_on_section_id"
  add_index "members", ["student_id"], :name => "index_members_on_student_id"

  create_table "removals", :force => true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.boolean  "pass"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  add_index "removals", ["course_id"], :name => "index_removals_on_course_id"
  add_index "removals", ["student_id"], :name => "index_removals_on_student_id"

  create_table "schoolyears", :force => true do |t|
    t.integer  "start"
    t.text     "remarks"
    t.boolean  "current",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schoolyears", ["current"], :name => "index_schoolyears_on_current"

  create_table "sections", :force => true do |t|
    t.integer  "schoolyear_id"
    t.integer  "faculty_id"
    t.integer  "batch_id"
    t.integer  "year"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["batch_id"], :name => "index_sections_on_batch_id"
  add_index "sections", ["faculty_id"], :name => "index_sections_on_faculty_id"
  add_index "sections", ["schoolyear_id"], :name => "index_sections_on_schoolyear_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "students", :force => true do |t|
    t.integer  "student_no"
    t.integer  "batch_id"
    t.string   "last"
    t.string   "given"
    t.string   "middle"
    t.string   "nick"
    t.text     "address"
    t.date     "birthday"
    t.string   "mobile"
    t.string   "landline"
    t.string   "email"
    t.string   "religion"
    t.string   "entry"
    t.boolean  "graduate"
    t.boolean  "upcat"
    t.boolean  "disciplinary"
    t.string   "father"
    t.string   "foccupation"
    t.string   "foffice"
    t.string   "fcontact"
    t.string   "mother"
    t.string   "moccupation"
    t.string   "moffice"
    t.string   "mcontact"
    t.string   "guardian"
    t.string   "relationship"
    t.string   "gaddress"
    t.string   "gcontact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sex",               :default => "M"
    t.string   "elem_completed_in"
    t.date     "elem_completed_on"
    t.date     "citizenship"
  end

  add_index "students", ["batch_id"], :name => "index_students_on_batch_id"

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.decimal  "units",         :precision => 10, :scale => 2
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_pe",                                        :default => false
    t.integer  "ordinality",                                   :default => 0
  end

  add_index "subjects", ["department_id"], :name => "index_subjects_on_department_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                 :default => false
    t.integer  "role",                                  :default => 3
    t.boolean  "is_active",                             :default => true
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
