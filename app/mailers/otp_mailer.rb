class OtpMailer < ApplicationMailer
  
  def default_email(owner, variables = {})
    @owner = owner || params[:owner]
      
    @name = variables.try(:[], :name) || @owner.try(:name)
    @otp = variables.try(:[], :email_otp) || @owner.try(:email_otp)
    @email = variables.try(:[], :email) || @owner.try(:email)

    mail(to: @email, subject: 'Verify your email address')
  end
end
