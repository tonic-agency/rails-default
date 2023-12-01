ActiveAdmin.register TimeDepositAccount do
  menu parent: 'Financial Data/Accounts', priority: 3

  permit_params :user_id, :amount, :start_date, :maturity_date, :base_interest_rate, :expected_base_interest, :auto_renewal, :state, :realised_interest

  scope :all, default: true
  scope :open
  scope :matured
  scope :cancelled

  filter :user 
  filter :start_date
  filter :maturity_date
  filter :created_at
  filter :state, as: :select, collection: TimeDepositAccount.states.map{|k,v| [v, k]}
  
  form do |f|
    f.inputs do
      f.input :user_id, as: :select, collection: User.all.order(:id).map{|u| ["#{u.id}: #{u.first_name} #{u.last_name}", u.id]}
      f.input :amount, as: :number, step: 0.01, min: 0.00
      f.input :start_date
      f.input :maturity_date
      f.input :base_interest_rate
      f.input :expected_base_interest
      f.input :state, as: :select, collection: TimeDepositAccount.states.map{|k,v| [v, k]}
      f.input :auto_renewal
      f.input :realised_interest
    end
    f.actions
  end

  show do 
    attributes_table do
      row :user_id
      row :amount
      row :start_date
      row :maturity_date
      row :base_interest_rate
      row :expected_base_interest
      row :state
      row :auto_renewal
      row :realised_interest
      row :corresponding_transaction do |time_deposit_account|
        link_to "Transaction ##{time_deposit_account.related_transaction.id}", admin_transaction_path(time_deposit_account.related_transaction)
      end
    end
  end
end