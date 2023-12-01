ActiveAdmin.register AdminUser do
  menu parent: 'Settings/Config'
  
  permit_params :email, :password, :password_confirmation, :first_name, :last_name

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name, as: :string
      f.input :last_name, as: :string
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

end
