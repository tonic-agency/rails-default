class AppController < ApplicationController
  before_action :authenticate_user_otp!, except: [:terms_and_conditions]

  def home
    return redirect_to root_path unless current_user.present?
    @open_time_deposits = current_user.time_deposit_accounts.where(state: 'open').order(created_at: :desc)
    @mature_time_deposits = current_user.time_deposit_accounts.where(state: 'matured').order(created_at: :desc)
  end

  def terms_and_conditions
  end

  private
  def transaction_params
    params.require(:transaction).permit(
      :amount
    )
  end
end