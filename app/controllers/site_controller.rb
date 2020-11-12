class SiteController < ApplicationController

  before_action :allow_iframe

  def index 
  end

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOWALL"
  end
  
end