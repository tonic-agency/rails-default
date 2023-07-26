class SiteController < ApplicationController

  before_action :allow_iframe

  def show_docs_page 
    params[:file].present? ? @filename = "docs/#{params[:file]}.md" : @filename = "readme.md"
    @content = Utilities.markdown_to_html("#{@filename}")
  end

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOWALL"
  end
  
end