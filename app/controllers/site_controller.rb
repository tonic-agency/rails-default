class SiteController < ApplicationController

  # TODO: Remove this. Coding offline and can't remember one-liner to include the auth token in the form
  skip_before_action :verify_authenticity_token, :only => [:plain_remote_form, :remote_form]

  def show_docs_page 
    params[:file].present? ? @filename = "docs/#{params[:file]}.md" : @filename = "readme.md"
    @content = Utilities.markdown_to_html("#{@filename}")
  end

  def show_snippet
    
    if params[:file].present?
      @filename = "examples/#{params[:file]}" 
    end
    full_path = Rails.root.join('app', 'views', 'examples', "#{params[:file]}.html.erb")

    @parsed_content = FrontMatterParser::Parser.parse_file(full_path)
    @page_title = @parsed_content.front_matter.try(:[],"title") || params[:file].titleize

    render :template => @filename, :layout => "examples"
  end

  def snippets

    if params[:snippet].present?
      @filename = "examples/#{params[:snippet]}" 

      full_path = Rails.root.join('app', 'views', 'examples', "#{params[:snippet]}.html.erb")

      @parsed_content = FrontMatterParser::Parser.parse_file(full_path)
      @page_title = @parsed_content.front_matter.try(:[],"title") || params[:file].titleize
    end

  end

  def plain_remote_form 
    render partial: "partials/plain_remote_form", layout: false
  end

  def remote_form 
    if request.post?
      @user = User.new(user_params)
      # For the purposes of demonstration, set a password here to allow persistence.
      pw = SecureRandom.hex(10)
      @user.password = pw 
      @user.password_confirmation = pw 
      @user.save
    end
    render partial: "partials/remote_form", layout: false
  end

  def user_params
    params.require(:user).permit(:email,:first_name,:last_name)
  end
  
end