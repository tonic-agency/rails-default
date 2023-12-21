class AddFundsMailer < ApplicationMailer

  def transaction_created(transaction, variables = {})
    @transaction = transaction
    @recipient = @transaction.to_settlement_account.user
    
    mail(to: @recipient.email, subject: 'Your Farmbank Fund Transfer is Being Verified')
  end

  def transaction_cleared(transaction, variables = {})
    @transaction = transaction
    @recipient = @transaction.to_settlement_account.user
    
    mail(to: @recipient.email, subject: 'Confirmation: Funds Successfully Added to Your Farmbank Account')
  end

  def transaction_rejected(transaction, variables = {})
    @transaction = transaction
    @recipient = @transaction.to_settlement_account.user
    
    mail(to: @recipient.email, subject: 'Your Farmbank Fund Transfer Has Been Rejected')
  end
end
