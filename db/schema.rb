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

ActiveRecord::Schema[8.0].define(version: 2025_08_30_091926) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "backstops", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id", null: false
    t.string "title"
    t.text "description"
    t.date "due_date"
    t.bigint "assigned_to_id"
    t.integer "status", default: 0, null: false
    t.integer "priority", default: 1, null: false
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_backstops_on_assigned_to_id"
    t.index ["created_by_id"], name: "index_backstops_on_created_by_id"
    t.index ["project_id"], name: "index_backstops_on_project_id"
    t.index ["ref"], name: "index_backstops_on_ref", unique: true
  end

  create_table "bills", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id", null: false
    t.bigint "supplier_id", null: false
    t.bigint "item_line_id"
    t.string "bill_number", null: false
    t.decimal "amount"
    t.decimal "tax_amount"
    t.decimal "total_amount"
    t.date "issue_date"
    t.date "due_date"
    t.integer "status", default: 0
    t.date "payment_date"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_number"], name: "index_bills_on_bill_number", unique: true
    t.index ["item_line_id"], name: "index_bills_on_item_line_id"
    t.index ["project_id"], name: "index_bills_on_project_id"
    t.index ["ref"], name: "index_bills_on_ref", unique: true
    t.index ["supplier_id"], name: "index_bills_on_supplier_id"
  end

  create_table "calendar_events", force: :cascade do |t|
    t.string "ref", null: false
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "all_day", default: false
    t.integer "event_type", default: 0
    t.string "color"
    t.bigint "project_id"
    t.bigint "meeting_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_calendar_events_on_created_by_id"
    t.index ["meeting_id"], name: "index_calendar_events_on_meeting_id"
    t.index ["project_id"], name: "index_calendar_events_on_project_id"
    t.index ["ref"], name: "index_calendar_events_on_ref", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "ref", null: false
    t.string "company"
    t.string "contact_name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "website"
    t.string "industry"
    t.integer "status", default: 0, null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_clients_on_created_by_id"
    t.index ["ref"], name: "index_clients_on_ref", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id"
    t.bigint "client_id"
    t.bigint "supplier_id"
    t.bigint "folder_id"
    t.string "name"
    t.string "file_path"
    t.bigint "file_size"
    t.string "file_type"
    t.bigint "uploaded_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_documents_on_client_id"
    t.index ["folder_id"], name: "index_documents_on_folder_id"
    t.index ["project_id"], name: "index_documents_on_project_id"
    t.index ["ref"], name: "index_documents_on_ref", unique: true
    t.index ["supplier_id"], name: "index_documents_on_supplier_id"
    t.index ["uploaded_by_id"], name: "index_documents_on_uploaded_by_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id"
    t.bigint "parent_id"
    t.string "name"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_folders_on_created_by_id"
    t.index ["parent_id"], name: "index_folders_on_parent_id"
    t.index ["project_id"], name: "index_folders_on_project_id"
    t.index ["ref"], name: "index_folders_on_ref", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id", null: false
    t.bigint "client_id", null: false
    t.string "invoice_number", null: false
    t.decimal "amount"
    t.decimal "tax_amount"
    t.decimal "total_amount"
    t.date "issue_date"
    t.date "due_date"
    t.integer "status", default: 0
    t.date "payment_date"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "item_line_id"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["created_by_id"], name: "index_invoices_on_created_by_id"
    t.index ["invoice_number"], name: "index_invoices_on_invoice_number", unique: true
    t.index ["item_line_id"], name: "index_invoices_on_item_line_id"
    t.index ["project_id"], name: "index_invoices_on_project_id"
    t.index ["ref"], name: "index_invoices_on_ref", unique: true
  end

  create_table "item_lines", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id", null: false
    t.bigint "parent_id"
    t.string "item_line"
    t.integer "level"
    t.string "contractor"
    t.string "unit"
    t.decimal "quantity"
    t.decimal "unit_price"
    t.decimal "estimated_cost"
    t.decimal "actual_cost"
    t.decimal "estimated_revenue"
    t.decimal "actual_revenue"
    t.date "start_date"
    t.date "due_date"
    t.integer "status", default: 0
    t.bigint "depends_on_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cost_code"
    t.string "parent_cost_code"
    t.bigint "supplier_id"
    t.index ["created_by_id"], name: "index_item_lines_on_created_by_id"
    t.index ["depends_on_id"], name: "index_item_lines_on_depends_on_id"
    t.index ["parent_id"], name: "index_item_lines_on_parent_id"
    t.index ["project_id"], name: "index_item_lines_on_project_id"
    t.index ["ref"], name: "index_item_lines_on_ref", unique: true
    t.index ["supplier_id"], name: "index_item_lines_on_supplier_id"
  end

  create_table "meeting_participants", force: :cascade do |t|
    t.bigint "meeting_id", null: false
    t.bigint "user_id"
    t.bigint "client_id"
    t.bigint "supplier_id"
    t.integer "response", default: 0
    t.index ["client_id"], name: "index_meeting_participants_on_client_id"
    t.index ["meeting_id"], name: "index_meeting_participants_on_meeting_id"
    t.index ["supplier_id"], name: "index_meeting_participants_on_supplier_id"
    t.index ["user_id"], name: "index_meeting_participants_on_user_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id"
    t.string "title"
    t.text "description"
    t.datetime "meeting_date"
    t.integer "duration_minutes"
    t.string "location"
    t.integer "meeting_type", default: 0
    t.bigint "organizer_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_meetings_on_organizer_id"
    t.index ["project_id"], name: "index_meetings_on_project_id"
    t.index ["ref"], name: "index_meetings_on_ref", unique: true
  end

  create_table "notes", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id"
    t.bigint "client_id"
    t.bigint "supplier_id"
    t.bigint "user_id"
    t.string "title"
    t.text "content"
    t.integer "note_type", default: 0
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_notes_on_client_id"
    t.index ["created_by_id"], name: "index_notes_on_created_by_id"
    t.index ["project_id"], name: "index_notes_on_project_id"
    t.index ["ref"], name: "index_notes_on_ref", unique: true
    t.index ["supplier_id"], name: "index_notes_on_supplier_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id", null: false
    t.string "title"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.integer "priority", default: 1, null: false
    t.date "start_date"
    t.date "end_date"
    t.bigint "assigned_to_id"
    t.bigint "depends_on_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "participants", default: [], array: true
    t.index ["assigned_to_id"], name: "index_objectives_on_assigned_to_id"
    t.index ["created_by_id"], name: "index_objectives_on_created_by_id"
    t.index ["depends_on_id"], name: "index_objectives_on_depends_on_id"
    t.index ["project_id"], name: "index_objectives_on_project_id"
    t.index ["ref"], name: "index_objectives_on_ref", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "ref", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name", unique: true
    t.index ["ref"], name: "index_organizations_on_ref", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "invoice_id"
    t.decimal "amount"
    t.string "payment_method"
    t.date "payment_date"
    t.string "reference_number"
    t.text "notes"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payable_type"
    t.bigint "payable_id"
    t.index ["created_by_id"], name: "index_payments_on_created_by_id"
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
    t.index ["payable_type", "payable_id"], name: "index_payments_on_payable_type_and_payable_id"
    t.index ["ref"], name: "index_payments_on_ref", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "ref", null: false
    t.string "name"
    t.text "description"
    t.bigint "client_id"
    t.integer "status", default: 0, null: false
    t.date "start_date"
    t.date "end_date"
    t.decimal "budget", precision: 12, scale: 2
    t.bigint "project_manager_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["created_by_id"], name: "index_projects_on_created_by_id"
    t.index ["project_manager_id"], name: "index_projects_on_project_manager_id"
    t.index ["ref"], name: "index_projects_on_ref", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.string "ref", null: false
    t.string "name"
    t.integer "report_type", default: 0
    t.text "project_ids", default: [], array: true
    t.date "date_range_start"
    t.date "date_range_end"
    t.jsonb "parameters"
    t.string "file_path"
    t.bigint "generated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["generated_by_id"], name: "index_reports_on_generated_by_id"
    t.index ["ref"], name: "index_reports_on_ref", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "ref", null: false
    t.string "company"
    t.string "contact_name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "website"
    t.string "category"
    t.integer "status", default: 0, null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_suppliers_on_created_by_id"
    t.index ["ref"], name: "index_suppliers_on_ref", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "objective_id", null: false
    t.string "title"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.integer "priority", default: 1, null: false
    t.date "start_date"
    t.date "due_date"
    t.bigint "assigned_to_id"
    t.decimal "estimated_hours", precision: 5, scale: 2
    t.decimal "actual_hours", precision: 5, scale: 2
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "participants", default: [], array: true
    t.index ["assigned_to_id"], name: "index_tasks_on_assigned_to_id"
    t.index ["created_by_id"], name: "index_tasks_on_created_by_id"
    t.index ["objective_id"], name: "index_tasks_on_objective_id"
    t.index ["ref"], name: "index_tasks_on_ref", unique: true
  end

  create_table "team_costs", force: :cascade do |t|
    t.string "ref", null: false
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.decimal "hours_worked"
    t.decimal "hourly_rate"
    t.decimal "total_cost"
    t.date "work_date"
    t.text "description"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_team_costs_on_created_by_id"
    t.index ["project_id"], name: "index_team_costs_on_project_id"
    t.index ["ref"], name: "index_team_costs_on_ref", unique: true
    t.index ["user_id"], name: "index_team_costs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "ref", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "full_name"
    t.string "avatar_url"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.string "position"
    t.string "department"
    t.string "phone"
    t.text "address"
    t.decimal "wage_per_hour", precision: 8, scale: 2
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["ref"], name: "index_users_on_ref", unique: true
  end

  add_foreign_key "backstops", "projects"
  add_foreign_key "backstops", "users", column: "assigned_to_id"
  add_foreign_key "backstops", "users", column: "created_by_id"
  add_foreign_key "bills", "item_lines"
  add_foreign_key "bills", "projects"
  add_foreign_key "bills", "suppliers"
  add_foreign_key "bills", "users", column: "created_by_id"
  add_foreign_key "calendar_events", "meetings"
  add_foreign_key "calendar_events", "projects"
  add_foreign_key "calendar_events", "users", column: "created_by_id"
  add_foreign_key "clients", "users", column: "created_by_id"
  add_foreign_key "documents", "clients"
  add_foreign_key "documents", "folders"
  add_foreign_key "documents", "projects"
  add_foreign_key "documents", "suppliers"
  add_foreign_key "documents", "users", column: "uploaded_by_id"
  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "folders", "projects"
  add_foreign_key "folders", "users", column: "created_by_id"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "item_lines"
  add_foreign_key "invoices", "projects"
  add_foreign_key "invoices", "users", column: "created_by_id"
  add_foreign_key "item_lines", "item_lines", column: "depends_on_id"
  add_foreign_key "item_lines", "item_lines", column: "parent_id"
  add_foreign_key "item_lines", "projects"
  add_foreign_key "item_lines", "suppliers"
  add_foreign_key "item_lines", "users", column: "created_by_id"
  add_foreign_key "meeting_participants", "clients"
  add_foreign_key "meeting_participants", "meetings"
  add_foreign_key "meeting_participants", "suppliers"
  add_foreign_key "meeting_participants", "users"
  add_foreign_key "meetings", "projects"
  add_foreign_key "meetings", "users", column: "organizer_id"
  add_foreign_key "notes", "clients"
  add_foreign_key "notes", "projects"
  add_foreign_key "notes", "suppliers"
  add_foreign_key "notes", "users"
  add_foreign_key "notes", "users", column: "created_by_id"
  add_foreign_key "objectives", "objectives", column: "depends_on_id"
  add_foreign_key "objectives", "projects"
  add_foreign_key "objectives", "users", column: "assigned_to_id"
  add_foreign_key "objectives", "users", column: "created_by_id"
  add_foreign_key "payments", "invoices"
  add_foreign_key "payments", "users", column: "created_by_id"
  add_foreign_key "projects", "clients"
  add_foreign_key "projects", "users", column: "created_by_id"
  add_foreign_key "projects", "users", column: "project_manager_id"
  add_foreign_key "reports", "users", column: "generated_by_id"
  add_foreign_key "suppliers", "users", column: "created_by_id"
  add_foreign_key "tasks", "objectives"
  add_foreign_key "tasks", "users", column: "assigned_to_id"
  add_foreign_key "tasks", "users", column: "created_by_id"
  add_foreign_key "team_costs", "projects"
  add_foreign_key "team_costs", "users"
  add_foreign_key "team_costs", "users", column: "created_by_id"
  add_foreign_key "users", "organizations"
end
