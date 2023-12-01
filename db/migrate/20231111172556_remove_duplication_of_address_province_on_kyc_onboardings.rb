class RemoveDuplicationOfAddressProvinceOnKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    remove_column :kyc_onboardings, :address_province, :string
    add_column :kyc_onboardings, :address_province, :string
  end
end
