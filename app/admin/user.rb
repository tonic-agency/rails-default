ActiveAdmin.register User do
  menu parent: 'Customer Onboarding', priority: 2

  index do 
    selectable_column
    column :id
    column :email
    column :authorized_to_create_transactions?
    column :settlement_account
    column :kyc_onboarding_check_result do |user|
      user.kyc_onboarding&.kyc_onboarding_check&.result
    end
    column :created_at

  end

end
