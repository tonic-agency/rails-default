class ModalsController < ApplicationController
  # Houses all modals fetched using htmx

  # Homepage
  def homepage_document_verification
    render partial: "modals/homepage/document_verification"
  end

  def homepage_referral_code_info
    render partial: "modals/homepage/referral_code_info"
  end
end