class AddFundsController < ApplicationController
  before_action :redirect_unless_authorized

  def new
    @transaction = current_user.settlement_account.incoming_transactions.new

    if request.post?
      
      @transaction.set_properties_for_type_add_funds(
        date: DateTime.now,
      )
      @transaction.assign_attributes(add_funds_params)
      
      @transaction.invoice_number_provided = add_funds_params[:invoice_number_provided] == "1" ? true : false

      if @transaction.save
        render partial: 'add_funds/success', locals: {transaction: @transaction}
      else
        @errors = @transaction.errors.full_messages
        render :new
      end
    end
  end

  def validate_amount
    @test_transaction = current_user.settlement_account.incoming_transactions.new
    @test_transaction.set_properties_for_type_add_funds(
      date: DateTime.now,
    )
    @test_transaction.assign_attributes(add_funds_params)
    
    if @test_transaction.invalid? && @test_transaction.errors.messages[:amount].any?
      render partial: "shared/inline_form_input_errors", locals: {errors: @test_transaction.errors.messages[:amount]}
    else
      head :ok
    end
  end

  def validate_deposit_slip
    @test_transaction = current_user.settlement_account.incoming_transactions.new
    
    @test_transaction.deposit_slip.attach(add_funds_params[:deposit_slip])
    @test_transaction.transaction_type = Transaction::TRANSACTION_TYPES[:add_funds][:identifier]

    if @test_transaction.invalid? && @test_transaction.errors.messages[:deposit_slip].any?
      render partial: "shared/inline_form_input_errors", locals: {errors: @test_transaction.errors.messages[:deposit_slip]}
    else
      head :ok
    end
  end

  def validate_invoice_number
    @test_transaction = current_user.settlement_account.incoming_transactions.new
    @test_transaction.set_properties_for_type_add_funds(
      date: DateTime.now,
    )
    @test_transaction.transaction_type = Transaction::TRANSACTION_TYPES[:add_funds][:identifier]
    @test_transaction.invoice_number = add_funds_params[:invoice_number]
    @test_transaction.invoice_number_provided = add_funds_params[:invoice_number_provided] == "1" ? true : false

    if @test_transaction.invalid? && @test_transaction.errors.messages[:invoice_number].any?
      render partial: "shared/inline_form_input_errors", locals: {errors: @test_transaction.errors.messages[:invoice_number]}
    else
      head :ok
    end
  end

  def validate_transaction
    return unless params[:field].present?

    field_to_validate = params[:field].to_sym
    
    @test_transaction = current_user.settlement_account.incoming_transactions.new
    
    @test_transaction.set_properties_for_type_add_funds(
      date: DateTime.now,
    )
    
    @test_transaction.assign_attributes(add_funds_params)
    @test_transaction.invoice_number_provided = add_funds_params[:invoice_number_provided] == "1" ? true : false
    @test_transaction.deposit_slip.attach(add_funds_params[:deposit_slip]) if add_funds_params[:deposit_slip].present?
    
    if @test_transaction.invalid? && @test_transaction.errors.messages[field_to_validate].any?
      render partial: "shared/inline_form_input_errors", locals: {errors: @test_transaction.errors.messages[field_to_validate]}
    else
      head :ok
    end
  end

  def redirect_unless_authorized
    return redirect_to app_home_path unless current_user&.authorized_to_create_transactions?
  end

  private
  def add_funds_params
    params.require(:transaction).permit(
      :amount,
      :deposit_slip,
      :invoice_number,
      :invoice_number_provided
    )
  end
end