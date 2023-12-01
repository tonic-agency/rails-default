class AppController < ApplicationController

  def home 
    @open_time_deposits = current_user.time_deposit_accounts.where(state: 'open').order(created_at: :desc)
    @mature_time_deposits = current_user.time_deposit_accounts.where(state: 'matured').order(created_at: :desc)
  end

  private
  def transaction_params
    params.require(:transaction).permit(
      :amount
    )
  end
end