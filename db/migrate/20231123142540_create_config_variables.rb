class CreateConfigVariables < ActiveRecord::Migration[7.0]
  def change
    create_table :config_variables do |t|
      t.string :name
      t.string :value
      t.string :description
      t.string :identifier
      t.integer :last_updated_by

      t.timestamps
    end
  end
end
