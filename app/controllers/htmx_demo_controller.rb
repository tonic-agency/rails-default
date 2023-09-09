class HtmxDemoController < ApplicationController

  def remote_content
    if params[:delay].present? && params[:delay].to_i > 0 
      sleep(params[:delay].to_i)
    end
    support_partial_response
  end

  def deferred_content
    support_partial_response
  end

  def dropdown_content
    support_partial_response
  end

  def toast_content
    support_partial_response
  end
  
end