class TimeDepositsController < ApplicationController
  before_action :redirect_unless_authorized
  before_action :authenticate_user_otp!

  def new  
    @current_step = params[:current_step] || "new_time_deposit"

    @time_deposit_account = current_user.time_deposit_accounts.new
    
    if request.post?
      @time_deposit_account.amount = time_deposit_account_params[:amount]
      
      if @time_deposit_account.save
        render :success
      else
        @errors = @time_deposit_account.errors.full_messages
        render :new
      end
    end
  end

  def validate_time_deposit 
    @test_time_deposit_account = current_user.time_deposit_accounts.new
    @test_time_deposit_account.amount = time_deposit_account_params[:amount]
    
    if !@test_time_deposit_account.valid? && @test_time_deposit_account.errors[:amount].present?
      render partial: "shared/inline_form_input_errors", locals: { errors: @test_time_deposit_account.errors.messages[:amount] }
    else
      head :ok
    end
  end

  def success
  end

  def redirect_unless_authorized
    return redirect_to app_home_path unless current_user&.authorized_to_create_transactions?
  end

  private
  def time_deposit_account_params
    params.require(:time_deposit).permit(
      :amount
    )
  end
end