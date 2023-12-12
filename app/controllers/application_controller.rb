class ApplicationController < ActionController::Base

  def support_partial_response
    if request.headers['HX-Request']
      @async_request = true
      render :layout => false
    else  
      render 
    end
  end

  def authenticate_user_otp!
    return unless current_user.login_otp.present?
    
    if current_user.login_otp.validated_at.nil?
      return redirect_to validate_user_otp_path
    end 
  end

  protected
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      return validate_user_otp_path if resource.login_otp.present? && resource.login_otp.validated_at.nil?
    end 
    
    super
  end
  
end