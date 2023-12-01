ActiveAdmin.register TransactionApproval do
  menu parent: "Financial Data/Accounts", priority: 2
  permit_params :admin_user_id, :result, :from_account_number, :from_account_institution_id, :transaction_id, :settlement_account_id

  before_save do |resource|
    if permitted_params[:transaction_approval][:from_account_number].present? && permitted_params[:transaction_approval][:from_account_institution_id].present?
      from_account = SettlementAccount.find_or_initialize_by(account_number: permitted_params[:transaction_approval][:from_account_number])
      from_account.institution_id = permitted_params[:transaction_approval][:from_account_institution_id]

      if from_account.save
        resource.settlement_account = from_account
        resource.corresponding_transaction.from_account_id = from_account.id
        resource.corresponding_transaction.from_account_type = Transaction::ACCOUNT_TYPES[:settlement][:identifier]
      end
    end
  end
  
  controller do
    def new
      super do
        if params[:transaction_id]
          resource.transaction_id = params[:transaction_id]
        end
        resource.admin_user_id = current_admin_user.id
      end
    end
  end
  
  index do
    selectable_column
    id_column
    column :admin_user
    column :corresponding_transaction
    column :result
    actions
  end

  show do
    attributes_table do
      row :id
      row :settlement_account do |ta| 
        if ta.settlement_account.present?
          link_to ta.settlement_account.account_number, admin_settlement_account_path(ta.settlement_account)
        end
      end
      row :admin_user
      row :corresponding_transaction
      row :result
    end
  end

  filter :admin_user_id
  filter :transaction_id
  filter :result

  form do |f|
    
    div class: 'grid grid-cols-2 gap-x-6' do
      h5 'Transaction Details', class: 'col-span-1 text-xl font-semibold'
      h5 'Verify', class: 'col-span-1 text-xl font-semibold'
      
      div class: 'border-r p-4' do
        div class: 'grid grid-cols-2 w-full' do
          label 'Date:', class: 'font-bold' 
          div  f.object.corresponding_transaction.date.strftime("%b %d, %Y at %I:%M%p")
        end
        div class: 'grid grid-cols-2 w-full' do
          label 'Amount:', class: 'font-bold' 
          div f.object.corresponding_transaction.amount 
        end
        div class: 'grid grid-cols-2 w-full' do
          label 'Balance:', class: 'font-bold'
          div f.object.corresponding_transaction&.balance || 'Nil'
        end
        div class: 'grid grid-cols-2 w-full' do
          label 'To Account Type:', class: 'font-bold'
          div f.object.corresponding_transaction.to_account_type&.titleize
        end
        div class: 'grid grid-cols-2 w-full' do
          label 'To Account:', class: 'font-bold'
          div do
            link_to f.object.corresponding_transaction.to_account_type == Transaction::ACCOUNT_TYPES[:settlement][:identifier] ? admin_settlement_account_path(f.object.corresponding_transaction.to_account) : admin_time_deposit_account_path(f.object.corresponding_transaction.to_account) do 
              "#{f.object.corresponding_transaction.to_account.user.name}"
            end
          end 
        end 
        div class: 'grid grid-cols-2 w-full' do
          label 'State:', class: 'font-bold'
          div f.object.corresponding_transaction.state&.titleize
        end
        div class: "w-full grid #{f.object.corresponding_transaction.deposit_slip.attached? ? 'grid-cols-1' : 'grid-cols-2'}" do 
          label 'Deposit Slip:', class: 'font-bold'
          div class: 'w-full' do 
            if f.object.corresponding_transaction&.deposit_slip&.attached?
              if f.object.corresponding_transaction.deposit_slip.blob.content_type == 'application/pdf'
                link_to f.object.corresponding_transaction.deposit_slip.url, target: '_blank', class: 'w-full ' do 
                  div class: 'inline-flex items-center' do inline_svg_tag 'heroicons/icon-link.svg', class: 'w-4 h-4' end
                  div class: 'inline-flex items-center' do "View Deposit Slip" end
                end
              else
                image_tag f.object.corresponding_transaction&.deposit_slip&.url, class: 'w-full'
              end
            else 
              "No deposit slip attached"
            end
          end
        end
      end

      div do
        f.inputs do
          f.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
          f.input :transaction_id, as: :hidden
          f.input :from_account_number, as: :string, input_html: { value: f.object&.settlement_account&.account_number || f.object.from_account_number  }
          f.input :from_account_institution_id, as: :select, collection: Institution.all.map{|institution| [institution.name, institution.id]}, selected: f.object&.settlement_account&.institution&.id || f.object.from_account_institution_id 
          f.input :result, as: :select, collection: TransactionApproval::RESULTS.map{|symbol,attributes| [attributes[:id].titleize, attributes[:id]]}
        end
        f.actions
      end
    end
  end

end