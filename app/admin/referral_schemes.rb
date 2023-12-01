ActiveAdmin.register ReferralScheme do
  permit_params :relative_balance, :referral_interest_rate
  menu parent: 'Referrals', priority: 1

  index do 
    selectable_column
    column :id
    column :relative_balance
    column :referral_interest_rate
    column :created_at
  end

  form do |f|
    f.inputs do 
      f.input :relative_balance
      f.input :referral_interest_rate
    end
    f.actions
  end

end