class ChangeTimeDepositAccountAutoRenewDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :time_deposit_accounts, :auto_renewal, from: false, to: true
  end
end
