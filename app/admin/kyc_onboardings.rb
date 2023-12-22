ActiveAdmin.register KycOnboarding do
  menu parent: 'Customer Onboarding', priority: 2
  
  scope :all, default: true
  scope :incomplete
  scope :submitted
  scope :pending_verification do |kyc|
    kyc.where(state: "submitted").includes(:kyc_onboarding_check).where(kyc_onboarding_checks: { id: nil })
  end
  scope :verified do |kyc|
    kyc.where(state: "submitted").includes(:kyc_onboarding_check).where(kyc_onboarding_checks: { result: "verified" })
  end
  scope :referred_to_farmbank do |kyc|
    kyc.where(was_referred: true)
  end

  filter :created_at
  filter :identifier
  filter :first_name_or_last_name_cont, as: :string, label: "Name"
  filter :email
  filter :phone
  filter :nationality
  filter :state, as: :select, collection: KycOnboarding::STATES.keys.map{|state| [state.to_s.humanize, state]}, include_blank: false
  filter :source_of_funds
  filter :work_occupation
  filter :work_employer_name

  index do
    div class: "flex items-start w-full rounded shadow mb-5 p-6 border" do
      div do 
        inline_svg_tag 'heroicons/icon-information.svg', class: "h-6 w-6"
      end
      div class: "pl-3" do
        para "Only applications that have been submitted can be verified."
        para "Only applications that have been verified can Add Funds and create Time Deposits in their account."
      end
    end
    selectable_column
    id_column
    column :created_at do |kyc|
      div style: "max-width: 100px" do 
        kyc.created_at.strftime("%d/%m/%Y %H:%M")
      end
    end
    column :identifier
    column :full_name do |kyc|
      div style: "max-width: 100px" do 
        kyc.name
      end 
    end
    column :user do |kyc|
      div style: "max-width: 100px" do
        if kyc.user
          link_to kyc&.user&.name, admin_user_path(kyc&.user), class: 'underline'
        end
      end
    end
    column :contact_details do |kyc|
      div style: "max-width: " do
        div do "📧: #{kyc&.email}" end
        div do "📞: #{kyc&.phone}" end
      end
    end
    column :application do |kyc|
      div style: "max-width: 100px" do
        link_to "View", admin_kyc_onboarding_path(kyc), class: 'underline'
      end
    end
    column :application_status do |kyc|
      status_tag kyc&.state&.titleize, style: kyc&.state == "submitted" ? "background: #46be8a" : "background: #b3b3b3"
    end
    column :verification_status do |kyc|
      if kyc.kyc_onboarding_check
        status_tag kyc.kyc_onboarding_check.result.titleize, style: kyc.kyc_onboarding_check.result == "verified" ? "background: #46be8a" : kyc.kyc_onboarding_check.result == "rejected" ? "background: #dc4747" : "background: #b3b3b3"
      end
    end
    column :verify do |kyc|
      if kyc&.eligible_for_verification?
        link_to "Verify", new_admin_kyc_onboarding_check_path(kyc_onboarding:kyc.id), class: "bg-gray-800 rounded p-2 text-white"
      end
    end
  end

  show do
    render partial: "admin/kyc_onboardings/show/custom_styles"
    div do
      h3 "Application info", class: 'font-bold mb-2'
      attributes_table_for resource do
        row :created_at
        row :updated_at
        row :identifier
        row :application_status do |kyc|
          status_tag kyc&.state&.titleize, style: kyc.state == "submitted" ? "background: #46be8a" : "background: #b3b3b3"
        end
        row :verification_status do |kyc|
          if kyc&.kyc_onboarding_check
            status_tag kyc&.kyc_onboarding_check&.result&.titleize, style: kyc&.kyc_onboarding_check&.result == "verified" ? "background: #46be8a" : kyc&.kyc_onboarding_check&.result == "rejected" ? "background: #dc4747" : "background: #b3b3b3"
          end
        end
        row :was_referred_to_farmbank do |kyc|
          status_tag kyc.was_referred
        end
        row :referral_code_used do |kyc|
          if kyc&.user&.referral
            kyc&.user&.referral&.referrer&.referral_code&.code
          else
            "N/A"
          end
        end
        row :referred_by do |kyc|
          if kyc&.user&.referral
            link_to kyc&.user&.referral&.referrer&.name, admin_user_path(kyc&.user&.referral&.referrer)
          else
            "N/A"
          end
        end
        row :accepted_terms_and_conditions do |kyc|
          status_tag kyc&.terms_accepted
        end
        row :link_to_verify do |kyc|
          if kyc.eligible_for_verification?
            link_to "Verify", new_admin_kyc_onboarding_check_path(kyc_onboarding: kyc.id), class: "bg-gray-800 rounded p-2 text-white"
          else
            "N/A"
          end
        end
      end
    end

    div class: 'mt-6' do
      h3 "Personal info", class: 'font-bold mb-2'
      attributes_table_for resource do
        row :name
        row :user do |kyc|
          if kyc.user
            link_to kyc&.user&.name, admin_user_path(kyc&.user)
          end
        end
        row :email
        row :phone
        row :address do |kyc|
          kyc&.full_address
        end
        row :date_of_birth
        row :place_of_birth
        row :nationality
        row :marital_status
      end
    end

    div class: 'mt-6' do 
      h3 "Financial info", class: 'font-bold mb-2'
      attributes_table_for resource do
        row :source_of_funds
        row :gross_monthly_income
        row :work_occupation
        row :work_employer_name
        row :work_employer_address
        row :work_employer_contact_number
        row 'TIN Present During Onboarding' do |kyc|
          status_tag kyc&.tin_known
        end
        row :tax_identification_number do |kyc| 
          kyc&.tin_known ? kyc&.tax_identification_number : "N/A"
        end
      end
    end

    div class: 'mt-6' do
      h3 "Identification", class: 'font-bold mb-2'
      attributes_table_for resource do
        row :id_file_front do |kyc|
          if kyc.id_file_front.attached?
            image_tag url_for(kyc&.id_file_front), style: "max-width: 300px"
          else 
            "Empty"
          end
        end
        row :id_file_back do |kyc|
          if kyc.id_file_back.attached?
            image_tag url_for(kyc&.id_file_back), style: "max-width: 300px"
          else 
            "Empty"
          end
        end
        row :signature_present_at_onboarding
        row :signature_id do |kyc|
          if kyc.signature_id.attached?
            image_tag url_for(kyc&.signature_id), style: "max-width: 300px"
          else 
            "Empty"
          end
        end
      end
    end
  end
end
