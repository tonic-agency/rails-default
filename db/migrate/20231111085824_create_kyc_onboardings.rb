class CreateKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    create_table :kyc_onboardings do |t|
      t.text :first_name
      t.text :last_name
      t.text :middle_name
      t.datetime :date_of_birth
      t.text :place_of_birth
      t.text :nationality
      t.string :marital_status
      t.text :address_house_number
      t.text :address_street_name
      t.text :address_province
      t.text :address_city
      t.text :address_barangay
      t.text :address_country
      t.text :work_occupation
      t.text :work_employer_name
      t.text :work_employer_address
      t.text :work_employer_contact_number
      t.string :source_of_funds
      t.text :gross_monthly_income
      t.text :tax_identification_number
      t.text :ssis_gsis_number

      t.timestamps
    end
  end
end
