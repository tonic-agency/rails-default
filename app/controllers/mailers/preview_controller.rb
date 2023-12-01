class Mailers::PreviewController < ApplicationController

  def kyc_onboarding_verification_in_progress
    @kyc_onboarding = KycOnboarding.last
    @user = @kyc_onboarding.user
    @account_url = Rails.application.routes.url_helpers.app_home_url(:host => request.host_with_port)

    render 'kyc_onboarding_mailer/account_verification_in_progress_email', :layout => 'mailer'
  end

end
