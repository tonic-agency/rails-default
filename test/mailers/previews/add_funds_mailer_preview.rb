# Preview all emails at http://localhost:3000/rails/mailers/add_funds_mailer
class AddFundsMailerPreview < ActionMailer::Preview
  def transaction_created
    AddFundsMailer.transaction_created(Transaction.pending.add_funds.last)
  end

  def transaction_cleared 
    AddFundsMailer.transaction_cleared(Transaction.cleared.add_funds.last)
  end
end
