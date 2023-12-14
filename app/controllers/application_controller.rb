class ApplicationController < ActionController::Base
  include FeatureFlagsHelper

  def support_partial_response
    if request.headers['HX-Request']
      @async_request = true
      render :layout => false
    else  
      render 
    end
  end

  helper_method :feature_flag?

  def authenticate_user_otp!
    return unless feature_flag?('2FA_ENABLED')
    return unless current_user.login_otp.present?
    
    if current_user.login_otp.validated_at.nil?
      return redirect_to validate_user_otp_path
    end 
  end

  protected
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && feature_flag?('2FA_ENABLED')
      return validate_user_otp_path if resource.login_otp.present? && resource.login_otp.validated_at.nil?
    else 
      return app_home_path
    end 

  end
  
end