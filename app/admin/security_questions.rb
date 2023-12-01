ActiveAdmin.register SecurityQuestion do
  menu parent: 'Customer Onboarding', priority: 2
  
  permit_params :kyc_onboarding_id, :question, :answer

  form do |f|
    f.inputs do
      f.input :kyc_onboarding
      f.input :question, as: :select, collection: SecurityQuestion.questions.values
      f.input :answer
    end
    f.actions
  end
end