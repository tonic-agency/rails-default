class KycOnboardingsController < ApplicationController

  def start
  end
  
  def new
    if params[:code].present?
      @kyc_onboarding = KycOnboarding.find_by_identifier(params[:code])
    else
      @kyc_onboarding = KycOnboarding.new
    end
    
    @current_step = params[:current_step] || @kyc_onboarding.current_step

    if @kyc_onboarding.current_step == "security_questions"
      @security_question_1 = @kyc_onboarding.security_questions.first
      @security_question_2 = @kyc_onboarding.security_questions.second
    end

    if request.post?
      @kyc_onboarding.assign_attributes(new_kyc_onboarding_params)
      
      if @kyc_onboarding.current_step == "mobile_otp"
        mobile_otp_to_validate = new_kyc_onboarding_params.values_at(:mobile_otp_1, :mobile_otp_2, :mobile_otp_3, :mobile_otp_4, :mobile_otp_5, :mobile_otp_6).join
        @kyc_onboarding.mobile_otp_to_validate = mobile_otp_to_validate
      end

      if @kyc_onboarding.current_step == "email_otp"
        email_otp_to_validate = new_kyc_onboarding_params.values_at(:email_otp_1, :email_otp_2, :email_otp_3, :email_otp_4, :email_otp_5, :email_otp_6).join
        @kyc_onboarding.email_otp_to_validate = email_otp_to_validate
      end

      if @current_step == "signature_specimen" && new_kyc_onboarding_params[:signature_id].blank?
        @kyc_onboarding.signature_id.blob.purge if @kyc_onboarding.signature_id.blob.present?
      end
      
      if @kyc_onboarding.save
        if @kyc_onboarding.user.present?
          sign_in(@kyc_onboarding.user)
        end
        
        if params[:current_step].present? 
          next_step = @kyc_onboarding.next_step(params[:current_step])
          redirect_to new_kyc_onboarding_path(code: @kyc_onboarding.identifier, current_step: next_step)
        else
          redirect_to new_kyc_onboarding_path(code: @kyc_onboarding.identifier)
        end
      end
    end
  end

  def summary
    @kyc_onboarding = KycOnboarding.find_by_identifier(params[:code])
    @kyc_onboarding.assign_attributes(new_kyc_onboarding_params)
    @kyc_onboarding.save
    render partial: "kyc_onboardings/summary_step_nested_forms/#{params[:step]}_form"
  end

  def submit 
    @kyc_onboarding = KycOnboarding.find_by_identifier(params[:kyc_onboarding_identifier])
    
    if @kyc_onboarding.submit!
      if feature_flag?('2FA_ENABLED')
        @kyc_onboarding.user.login_otp.mobile = @kyc_onboarding.phone
        @kyc_onboarding.user.login_otp.send_sms
        redirect_to validate_user_otp_path(welcome: true)
      else
        redirect_to app_home_path
      end
    end
  end 

  def new_kyc_onboarding_params
    params.require(:kyc_onboarding).permit(
      :validation_set,
      :first_name, 
      :last_name, 
      :middle_name, 
      :phone,
      :mobile_otp_1,
      :mobile_otp_2,
      :mobile_otp_3,
      :mobile_otp_4,
      :mobile_otp_5,
      :mobile_otp_6,
      :email,
      :email_otp_1,
      :email_otp_2,
      :email_otp_3,
      :email_otp_4,
      :email_otp_5,
      :email_otp_6,
      :date_of_birth,
      :place_of_birth,
      :nationality,
      :marital_status,
      :password,
      :password_confirmation,
      :address_house_number,
      :address_street_name,
      :address_province,
      :address_city,
      :address_barangay,
      :address_country,
      :source_of_funds,
      :gross_monthly_income,
      :work_occupation,
      :work_employer_name,
      :work_employer_address,
      :work_employer_contact_number,
      :tin_known,
      :tax_identification_number,
      :ssis_gsis_number, 
      :signature_present_at_onboarding,
      :id_file_front,
      :id_file_back,
      :signature_id,
      :was_referred,
      :referral_code,
      :mobile_otp_code,
      :email_otp_code,
      security_questions_attributes: [
        :id,
        :question,
        :answer,
      ]
    )
  end

end