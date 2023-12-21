ActiveAdmin.register TransactionApproval do
  menu parent: "Financial Data/Accounts", priority: 2
  permit_params :admin_user_id, :result, :transaction_id, :settlement_account_id
  # :from_account_number, :from_account_institution_id,

  # before_save do |resource|
  #   if permitted_params[:transaction_approval][:from_account_number].present? && permitted_params[:transaction_approval][:from_account_institution_id].present?
  #     from_account = SettlementAccount.find_or_initialize_by(account_number: permitted_params[:transaction_approval][:from_account_number])
  #     from_account.institution_id = permitted_params[:transaction_approval][:from_account_institution_id]

  #     if from_account.save
  #       resource.settlement_account = from_account
  #       resource.corresponding_transaction.from_account_id = from_account.id
  #       resource.corresponding_transaction.from_account_type = Transaction::ACCOUNT_TYPES[:settlement][:identifier]
  #     end
  #   end
  # end
  
  controller do
    def new
      unless params[:transaction_id].present?
        return redirect_to admin_transactions_path, alert: "Transaction must be present"
      end 

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
      row :from_account do |ta| 
        if ta&.corresponding_transaction&.from_account&.present?
          link_to ta&.corresponding_transaction&.from_account&.name, admin_settlement_account_path(ta&.corresponding_transaction&.from_account)
        end
      end
      row :settlement_account do |ta|
        if ta&.settlement_account&.present?
          link_to ta&.settlement_account&.name, admin_settlement_account_path(ta&.settlement_account)
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
        div class: 'grid grid-cols-2 w-full' do
          label 'Transaction Type:', class: 'font-bold'
          div f.object.corresponding_transaction.transaction_type&.titleize
        end
        div class: 'grid grid-cols-2 w-full' do
          label 'Deposit Type:', class: 'font-bold'
          div f.object.corresponding_transaction.deposit_type&.titleize
        end
        if f.object.corresponding_transaction.of_deposit_type_online_transfer?
          div class: 'grid grid-cols-2 w-full' do
            label 'Bank Account Number:', class: 'font-bold'
            div f.object.corresponding_transaction&.bank_account_number || 'N/A'
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
        elsif f.object.corresponding_transaction.of_deposit_type_check_deposit?
          div class: 'grid grid-cols-2 w-full' do
            label 'Check:', class: 'font-bold'
            div class: 'w-full' do 
              if f.object.corresponding_transaction&.check&.attached?
                if f.object.corresponding_transaction.check.blob.content_type == 'application/pdf'
                  link_to f.object.corresponding_transaction.check.url, target: '_blank', class: 'w-full ' do 
                    div class: 'inline-flex items-center' do inline_svg_tag 'heroicons/icon-link.svg', class: 'w-4 h-4' end
                    div class: 'inline-flex items-center' do "View Check" end
                  end
                else
                  image_tag f.object.corresponding_transaction&.check&.url, class: 'w-full'
                end
              else 
                "No check attached"
              end
            end
          end
        end
      end

      div do
        f.inputs do
          div class: 'warning hidden p-6 my-6 rounded-lg bg-red-100 border text-gray-600 border-red-500' do 
            div class: 'text-lg font-semibold' do 'Warning:' end
            div class: '' do "Please note - if you would like to mark this transaction as being 'from' a Settlement Account that already exists in our system, you will need to be sure that the corresponding Settlement Account has a Bank Account Number, and that it matches exactly the number inputted below." end
            div class: 'mt-2' do "Otherwise, our system will create a new Settlement Account with the number + Institution provided below. This is to allow for marking Transactions as coming from outside Banks." end
            div class: 'mt-2' do 
              div do 
                "To update the account number of an already existing Settlement Account before proceeding, you can do so by navigating to edit it here 👇"
              end
              div do link_to 'Settlement Accounts', admin_settlement_accounts_path, class: 'font-semibold underline', target: '_blank' end
            end
          end
          # show errors
          f.object.errors.full_messages.each do |msg|
            div do 
              div class: 'my-2 text-red-500' do "*#{msg}" end
            end
          end
            
          f.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
          f.input :transaction_id, as: :hidden
          # f.input :from_account_number, as: :string, input_html: { value: f.object&.settlement_account&.account_number || f.object.from_account_number  }
          # f.input :from_account_institution_id, as: :select, collection: Institution.all.map{|institution| [institution.name, institution.id]}, selected: f.object&.settlement_account&.institution&.id || f.object.from_account_institution_id 
          f.input :result, as: :select, collection: TransactionApproval::RESULTS.map{|symbol,attributes| [attributes[:id].titleize, attributes[:id]]}
        end
        f.actions
      end
    end
  end

end