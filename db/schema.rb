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

ActiveRecord::Schema[7.0].define(version: 2023_12_12_173403) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "first_name"
    t.text "last_name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "config_variables", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.string "description"
    t.string "identifier"
    t.integer "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kyc_onboarding_checks", force: :cascade do |t|
    t.integer "admin_user_id"
    t.integer "kyc_onboarding_id"
    t.boolean "information_correct"
    t.boolean "id_correct"
    t.boolean "signature_validated"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kyc_onboardings", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "middle_name"
    t.datetime "date_of_birth"
    t.text "place_of_birth"
    t.text "nationality"
    t.string "marital_status"
    t.text "address_house_number"
    t.text "address_street_name"
    t.text "address_city"
    t.text "address_barangay"
    t.text "address_country"
    t.text "work_occupation"
    t.text "work_employer_name"
    t.text "work_employer_address"
    t.text "work_employer_contact_number"
    t.string "source_of_funds"
    t.text "gross_monthly_income"
    t.text "tax_identification_number"
    t.text "ssis_gsis_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.string "identifier"
    t.integer "user_id"
    t.text "email"
    t.text "phone"
    t.string "address_province"
    t.boolean "tin_known", default: true
    t.boolean "signature_present_at_onboarding", default: true
    t.boolean "was_referred"
    t.boolean "mobile_validated", default: false
    t.boolean "email_validated", default: false
  end

  create_table "otps", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "otp_type"
    t.string "value"
    t.datetime "validated_at"
    t.integer "invalid_attempts", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_otps_on_owner"
  end

  create_table "referral_codes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_referral_codes_on_user_id"
  end

  create_table "referral_schemes", force: :cascade do |t|
    t.decimal "relative_balance", default: "0.0", null: false
    t.decimal "referral_interest_rate", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referrals", force: :cascade do |t|
    t.bigint "from_id", null: false
    t.bigint "to_id", null: false
    t.bigint "referral_scheme_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_referrals_on_from_id"
    t.index ["referral_scheme_id"], name: "index_referrals_on_referral_scheme_id"
    t.index ["to_id"], name: "index_referrals_on_to_id"
  end

  create_table "security_questions", force: :cascade do |t|
    t.bigint "kyc_onboarding_id", null: false
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0
    t.index ["kyc_onboarding_id"], name: "index_security_questions_on_kyc_onboarding_id"
  end

  create_table "settlement_accounts", force: :cascade do |t|
    t.integer "institution_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number"
    t.string "account_name"
  end

  create_table "time_deposit_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.datetime "start_date"
    t.datetime "maturity_date"
    t.decimal "base_interest_rate"
    t.decimal "expected_base_interest"
    t.boolean "auto_renewal", default: true
    t.string "state"
    t.boolean "realised_interest", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_time_deposit_accounts_on_user_id"
  end

  create_table "transaction_approvals", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.bigint "admin_user_id", null: false
    t.string "result", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "settlement_account_id"
    t.index ["admin_user_id"], name: "index_transaction_approvals_on_admin_user_id"
    t.index ["settlement_account_id"], name: "index_transaction_approvals_on_settlement_account_id"
    t.index ["transaction_id"], name: "index_transaction_approvals_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "date"
    t.integer "from_account_id"
    t.integer "to_account_id"
    t.string "state"
    t.string "transaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from_account_type"
    t.string "to_account_type"
    t.decimal "balance", precision: 10, scale: 2
    t.string "bank_account_number"
    t.string "deposit_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.text "first_name"
    t.text "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "referral_codes", "users"
  add_foreign_key "referrals", "referral_schemes"
  add_foreign_key "referrals", "users", column: "from_id"
  add_foreign_key "referrals", "users", column: "to_id"
  add_foreign_key "security_questions", "kyc_onboardings"
  add_foreign_key "time_deposit_accounts", "users"
  add_foreign_key "transaction_approvals", "admin_users"
  add_foreign_key "transaction_approvals", "settlement_accounts"
  add_foreign_key "transaction_approvals", "transactions"
end
