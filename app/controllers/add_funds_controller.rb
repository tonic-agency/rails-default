class AddFundsController < ApplicationController
  before_action :redirect_unless_authorized
  before_action :authenticate_user_otp!

  def new
    @transaction = current_user.settlement_account.incoming_transactions.new

    if request.post?
      @transaction.set_properties_for_type_add_funds(
        date: DateTime.now,
      )
      @transaction.assign_attributes(add_funds_params)

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

  def validate_transaction
    return unless params[:field].present?

    field_to_validate = params[:field].to_sym
    
    @test_transaction = current_user.settlement_account.incoming_transactions.new
    
    @test_transaction.set_properties_for_type_add_funds(
      date: DateTime.now,
    )
    
    @test_transaction.assign_attributes(add_funds_params)
    
    @test_transaction.deposit_slip.attach(add_funds_params[:deposit_slip]) if add_funds_params[:deposit_slip].present?
    
    @test_transaction.check.attach(add_funds_params[:check]) if add_funds_params[:check].present?
    
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
      :deposit_type,
      :deposit_slip,
      :bank_account_number,
      :check
    )
  end
end