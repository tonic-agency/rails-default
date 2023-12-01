ActiveAdmin.register Referral do
  menu parent: 'Referrals', priority: 2

  index do 
    selectable_column
    column :id
    column :referrer
    column :referred_user
    column :referral_scheme
    column :created_at
  end

  form do |f|
    f.inputs do 
      f.input :referrer
      f.input :referred_user
      f.input :referral_scheme
    end
    f.actions
  end

end