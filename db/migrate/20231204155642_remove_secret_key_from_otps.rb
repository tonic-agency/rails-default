class RemoveSecretKeyFromOtps < ActiveRecord::Migration[7.0]
  def change
    remove_column :otps, :secret_key, :string
  end
end
