class CreateOtps < ActiveRecord::Migration[7.0]
  def change
    create_table :otps do |t|
      t.references :owner, polymorphic: true, null: false
      t.string :otp_type
      t.string :secret_key
      t.string :value 
      t.datetime :validated_at
      t.integer :invalid_attempts, default: 0

      t.timestamps
    end
  end
end
