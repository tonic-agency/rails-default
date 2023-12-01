ActiveAdmin.register ReferralCode do
  permit_params :user_id
  menu parent: 'Referrals', priority: 3

  index do 
    selectable_column
    column :id
    column :code
    column :user
    column :created_at
  end

  form do |f|
    f.inputs do 
      f.input :user
    end
    f.actions
  end

end