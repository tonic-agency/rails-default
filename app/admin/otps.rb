ActiveAdmin.register Otp do
  menu parent: 'Dev', label: 'OTP'
  permit_params :otp_type, :owner_id

  form do |f|
    f.inputs do
      f.input :otp_type, as: :select, collection: Otp::OTP_TYPES
      f.input :owner_id, as: :select, collection: User.all.map{|u| [u.email, u.id]}
    end
    f.actions
  end
end