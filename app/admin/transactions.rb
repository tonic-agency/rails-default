ActiveAdmin.register Transaction do
  menu parent: 'Financial Data/Accounts', priority: 3
  
  permit_params :from_account_id, :from_account_type, :state, :deposit_slip, transaction_approval_attributes: [:id, :admin_user_id, :transaction_id, :result]
  includes :deposit_slip_attachment, {from_settlement_account: :user}, {to_settlement_account: :user}, {from_time_deposit_account: :user}, {to_time_deposit_account: :user}

  scope :all, default: true
  scope :pending
  scope :add_funds
  scope :time_deposits

  filter :transaction_type, as: :select, collection: Transaction::TRANSACTION_TYPES.map{|symbol,attributes| [attributes[:identifier]&.titleize, attributes[:identifier] ]}

  actions :index, :show

  controller do
    def update 
      super do |format|
        if resource.valid? && resource.transaction_approval&.valid?
          format.html { redirect_to admin_transaction_path(resource) }
        else
          format.html { render :edit }
        end
      end 
    end
  end

  index do 
    selectable_column
    column :id
    column :amount
    column :balance
    column :from_account_type do |t| t.from_account_type&.titleize end
    column :from_account do |transaction|
      if transaction.from_account_type == Transaction::ACCOUNT_TYPES[:settlement][:identifier] && transaction.from_account_id.present?
        link_to transaction&.from_account&.name || "Account #{transaction&.from_account&.id}", admin_settlement_account_path(transaction&.from_account)
      elsif transaction.from_account_type == Transaction::ACCOUNT_TYPES[:time_deposit][:identifier]
        link_to transaction&.from_account&.name, admin_time_deposit_account_path(transaction&.from_account)
      end
    end
    column :to_account_type do |t| t.to_account_type&.titleize end
    column :to_account do |transaction|
      if transaction.to_account_type == Transaction::ACCOUNT_TYPES[:settlement][:identifier]
        link_to transaction&.to_account&.name, admin_settlement_account_path(transaction&.to_account)
      elsif transaction.to_account_type == Transaction::ACCOUNT_TYPES[:time_deposit][:identifier]
        link_to transaction&.to_account&.name, admin_time_deposit_account_path(transaction&.to_account)
      end
    end
    column :transaction_type do |t| t.transaction_type&.titleize end
    column :state do |t|
      div class: "inline-flex px-2 py-1 rounded-lg #{t.state_style_helper}" do
        t.state&.titleize
      end
    end
    column :date
    column :actions do |transaction|
      div class: 'inline-flex' do 
        link_to "View", admin_transaction_path(transaction), class: "bg-gray-600 rounded p-2 text-white text-xs"
      end
      if transaction.eligible_for_approval?
        div class: 'inline-flex' do 
          link_to "Verify", new_admin_transaction_approval_path(transaction_id: transaction.id), class: "rounded p-2 text-white text-xs ", style: 'background: #409384'
        end
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :amount
      row :balance
      row :from_account_type do |t| t.from_account_type&.titleize end
      row :from_account do |transaction|
        if transaction.from_account_type == Transaction::ACCOUNT_TYPES[:settlement][:identifier]
          link_to transaction&.from_account&.name, admin_settlement_account_path(transaction&.from_account)
        elsif transaction.from_account_type == Transaction::ACCOUNT_TYPES[:time_deposit][:identifier]
          link_to transaction&.from_account&.name, admin_time_deposit_account_path(transaction&.from_account)
        end
      end
      row :to_account_type do |t| t.to_account_type&.titleize end
      row :to_account do |transaction|
        if transaction.to_account_type == Transaction::ACCOUNT_TYPES[:settlement][:identifier]
          link_to transaction&.to_account&.name, admin_settlement_account_path(transaction&.to_account)
        elsif transaction.to_account_type == Transaction::ACCOUNT_TYPES[:time_deposit][:identifier]
          link_to transaction&.to_account&.name, admin_time_deposit_account_path(transaction&.to_account)
        end
      end
      row :transaction_type do |t| t.transaction_type&.titleize end
      row :state do |t|
        div class: "inline-flex px-2 py-1 rounded-lg #{t.state_style_helper}" do
          t.state&.titleize
        end
      end
      row :date
      row :deposit_slip do |transaction|
        if transaction.deposit_slip.present?
          link_to transaction&.deposit_slip&.url, target: '_blank' do 
            image_tag transaction&.deposit_slip&.url || '', class: 'w-80 h-80 object-contain'
          end
        else
          'No deposit slip attached'
        end
      end
      row :created_at
      row :updated_at
      if transaction.requires_approval?
        row :approved do |transaction|
          if transaction.transaction_approval.present?
            inline_svg_tag 'heroicons/icon-check-circle.svg', class: 'w-6 h-6 text-green-500'
          else
            inline_svg_tag 'heroicons/icon-x-circle.svg', class: 'w-6 h-6 text-red-500'
          end
        end
        if transaction.transaction_approval.present?
          row :transaction_approval do |transaction|
            link_to "Approval ##{transaction.transaction_approval.id}", admin_transaction_approval_path(transaction.transaction_approval)
          end
        else 
          row :transaction_approval do |transaction|
            div class: 'inline-flex' do
              link_to "Verify", new_admin_transaction_approval_path(transaction_id: transaction.id), class: "rounded p-2 text-white text-xs ", style: 'background: #409384'
            end
          end
        end
      end
    end
  end

end