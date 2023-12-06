module ConfigVariableHelper
  def config_variable(identifier)
    ConfigVariable.find_by_identifier(identifier).try(:value)
  end

  def farmbank_bank_account
    config_variable('default_company_bank_account') || nil 
  end

  def farmbank_support_email 
    config_variable('staff_support_email') || nil
  end
end