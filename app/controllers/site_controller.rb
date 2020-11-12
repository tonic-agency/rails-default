class SiteController < ApplicationController

  def index 
    response.headers["X-FRAME-OPTIONS"] = "ALLOWALL"
  end
  
end