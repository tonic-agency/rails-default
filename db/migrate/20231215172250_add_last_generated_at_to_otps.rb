class AddLastGeneratedAtToOtps < ActiveRecord::Migration[7.0]
  def change
    add_column :otps, :last_generated_at, :datetime
  end
end
