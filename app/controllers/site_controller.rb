class SiteController < ApplicationController

  before_action :allow_iframe

  def index 
    @content = Utilities.markdown_to_html("readme.md")
  end

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOWALL"
  end
  
end