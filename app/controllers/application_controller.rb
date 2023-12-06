class ApplicationController < ActionController::Base

  def support_partial_response
    if request.headers['HX-Request']
      @async_request = true
      render :layout => false
    else  
      render 
    end
  end

  protected
  def after_sign_in_path_for(resource)
    validate_user_otp_path
  end
  
end