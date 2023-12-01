module ConfigVariableHelper
  def config_variable(identifier)
    ConfigVariable.find_by_identifier(identifier).try(:value)
  end

  def farmbank_bank_account
    config_variable('default_company_bank_account') || nil 
  end
end