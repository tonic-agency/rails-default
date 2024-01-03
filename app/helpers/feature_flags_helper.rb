module FeatureFlagsHelper
  def feature_flag?(env_key)
    return false if env_key.blank?
    
    # returns whether value is true or false
    return ENV.fetch(env_key, false).to_s.casecmp('true').zero?
  end
end