ActiveAdmin.register KycOnboarding do
  menu parent: 'Customer Onboarding', priority: 2
  
  scope :incomplete
  scope :all, default: true

  index do 
    selectable_column
    id_column
    column :created_at
    column :identifier
    column :name
    column :email 
    column :phone
    column :user
    column :state
    column :result do |kyc|
      if kyc.kyc_onboarding_check
        kyc.kyc_onboarding_check.result
      end
    end
    column :verify do |kyc|
      if kyc.eligible_for_verification?
        link_to "Verify", new_admin_kyc_onboarding_check_path(kyc_onboarding:kyc.id), class: "bg-gray-800 rounded p-2 text-white"
      end
    end
  end

end
