class AddOrderToSecurityQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :security_questions, :order, :integer, default: 0
  end
end
