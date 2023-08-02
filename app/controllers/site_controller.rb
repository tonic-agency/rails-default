class SiteController < ApplicationController

  # TODO: Remove this. Coding offline and can't remember one-liner to include the auth token in the form
  skip_before_action :verify_authenticity_token, :only => [:plain_remote_form, :remote_form]

  def show_docs_page 
    params[:file].present? ? @filename = "docs/#{params[:file]}.md" : @filename = "readme.md"
    @content = Utilities.markdown_to_html("#{@filename}")
  end

  def remote_content
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