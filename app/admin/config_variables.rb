ActiveAdmin.register ConfigVariable do
  menu parent: 'Settings/Config'
  
  permit_params :identifier, :name, :value, :description
  
  filter :name
  filter :value

  controller do
    before_save do |config_variable|
      config_variable.last_updated_by = current_admin_user.id
    end
  end
  
  index do
    selectable_column
    id_column
    column :name
    column :value
    column :description
    column :last_updated_by do |config_variable|
      config_variable.whodunnit
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :identifier
      row :name
      row :value
      row :description
      row :last_updated_by do |config_variable|
        config_variable.whodunnit
      end
    end

    active_admin_comments
  end

  form do |f|
    
    f.inputs do
      if ['edit', 'update'].include?(params[:action])
        div class: " w-full py-4 bg-red-400 rounded border border-red-500 text-center mb-10" do
          h4 '*Please be aware that editing the value of a config variable can affect calculations & financial data in the system. Proceed with caution.',  class: 'text-white' 
        end
      end
      f.input :identifier
      f.input :name
      f.input :value
      f.input :description
    end
    f.actions
  end

end