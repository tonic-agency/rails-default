ActiveAdmin.register KycOnboardingCheck do
  menu parent: 'Customer Onboarding', priority: 2

  permit_params :information_correct, :id_correct, :signature_validated, :result, :kyc_onboarding_id

  controller do 
    def new
      super do 
        if params[:kyc_onboarding]
          resource.kyc_onboarding_id = params[:kyc_onboarding]
        end
        resource.admin_user_id = current_admin_user.id
      end
    end

  end
  
  form do |f|
    div class: "grid grid-cols-5 gap-x-5" do 
      div class: "col-span-3" do 
        @kyc_onboarding = f.object.kyc_onboarding
        render partial: "kyc_onboardings/summary_step"
      end
      div class: "col-span-2 bg-gray-50 rounded-lg p-5" do 
        f.inputs do
          div class: "font-bold text-2xl mb-5" do 
            "Review Panel"
          end
          div class:"flex pb-4" do 
            div class: "text-right pr-3 text-sm", style: "width: 25%" do 
              "Reviewed By:"
            end
            div style: "width: 75%" do 
              f.object&.admin_user&.name
            end
          end
          f.input :admin_user_id, as: :hidden, input_html: {value: f.object.admin_user_id || current_admin_user.id}
          f.input :kyc_onboarding_id, as: :hidden
          f.input :information_correct
          f.input :id_correct
          f.input :signature_validated
          f.input :result, as: :select, collection: f.object.class::STATES.keys.map{|state| [state.to_s.humanize, state]}, include_blank: false
        end
        f.actions
      end
    end
  end

end