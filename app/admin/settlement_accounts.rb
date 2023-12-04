ActiveAdmin.register SettlementAccount do
  menu parent: 'Financial Data/Accounts', priority: 3
  includes :user, :institution, :outgoing_transactions, :incoming_transactions

  permit_params :user_id, :institution_id, :account_number, :account_name

  scope :all, default: true
  # scope :internal
  # scope :external

  # filter :institution
  filter :name do |account|
    account.account_name || account.user&.name
  end

  form do |f|
    f.inputs do
      f.input :user_id, as: :select, collection: User.all.map{|u| ["#{u.id} #{u.first_name} #{u.last_name}", u.id]}
      # f.input :institution_id, as: :select, collection: Institution.all.map{|i| ["#{i.id}: #{i.name}", i.id]}
      # f.input :account_name, as: :string
      # f.input :account_number
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :user
    # column :account_number
    # column :institution
    column :total_cleared_outgoings
    column :total_cleared_incomings
    column :current_available_balance
    column :created_at
    column :updated_at
    actions
  end

  show do 
    attributes_table do
      row :id
      # row :name
      # row :account_number
      # row :institution
      row :current_available_balance
    end

    panel 'Outgoing Transactions', class: 'mt-5' do 
      table_for settlement_account.ordered_outgoing_transactions do
        column :id 
        column :amount
        column :balance
        column :state do |transaction|
          div class: "inline-flex px-2 py-1 rounded-lg #{transaction.state_style_helper}" do
            transaction.state&.titleize
          end
        end
        column :date 
        column :to_account_type 
        column :to_account do |transaction|
          transaction&.to_account&.user&.name
        end
        column :transaction_type do |transaction|
          transaction&.transaction_type&.titleize
        end
        column :deposit_slip do |transaction|
          link_to transaction&.deposit_slip&.blob&.filename, transaction&.deposit_slip&.url || '', target: '_blank'
        end
        
        column :verification do |transaction|
          if transaction.requires_approval? && transaction.transaction_approval.present?
            link_to "Verification ##{transaction.transaction_approval.id}", admin_transaction_approval_path(transaction.transaction_approval)
          end
        end

        column :actions do |transaction|
          div class: 'inline-flex 'do
            link_to 'View', admin_transaction_path(transaction), class: 'border hover:shadow rounded-md px-2 py-1'
          end
          if transaction.requires_approval? && transaction.transaction_approval.nil? 
            div class: 'inline-flex' do
              link_to 'Verify', new_admin_transaction_approval_path(transaction_id: transaction.id), class: "block rounded px-2 py-1 text-white text-xs", style: 'background: #409384'
            end
          end
        end
      end
    end

    panel 'Incoming Transactions', class: 'mt-5' do
      table_for settlement_account.ordered_incoming_transactions do |incoming_transaction|
        column :id 
        column :amount
        column :balance
        column :state do |transaction|
          div class: "inline-flex px-2 py-1 rounded-lg #{transaction.state_style_helper}" do
            transaction.state&.titleize
          end
        end
        column :date 
        column :from_account_type 
        column :from_account do |transaction|
          transaction&.from_account&.user&.name
        end
        column :transaction_type do |transaction|
          transaction&.transaction_type&.titleize
        end
        column :deposit_slip do |transaction|
          link_to transaction&.deposit_slip&.blob&.filename, transaction&.deposit_slip&.url || '', target: '_blank'
        end

        column :verification do |transaction|
          if transaction.requires_approval? && transaction.transaction_approval.present?
            link_to "Verification ##{transaction.transaction_approval.id}", admin_transaction_approval_path(transaction.transaction_approval)
          end
        end

        column :actions do |transaction|
          div class: 'inline-flex 'do
            link_to 'View', admin_transaction_path(transaction), class: 'border hover:shadow rounded-md px-2 py-1'
          end
          if transaction.requires_approval? && transaction.transaction_approval.nil? 
            div class: 'inline-flex' do
              link_to 'Verify', new_admin_transaction_approval_path(transaction_id: transaction.id), class: "block rounded px-2 py-1 text-white text-xs", style: 'background: #409384'
            end
          end
        end
      end
    end
  end
  
end