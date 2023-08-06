class ApplicationController < ActionController::Base

  def support_partial_response
    if request.headers['HX-Request']
      @async_request = true
      render :layout => false
    else  
      render 
    end
  end
  
end
