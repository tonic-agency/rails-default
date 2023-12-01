class RemoveOtpSecretKeyFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :otp_secret_key, :string
  end
end
