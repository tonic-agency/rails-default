class AddNamesToAdminUser < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :first_name, :text
    add_column :admin_users, :last_name, :text
  end
end
