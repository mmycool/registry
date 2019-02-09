CompanyRegister.configure do |config|
  config.username = ENV['arireg_username']
  config.password = ENV['arireg_password']
  config.wsdl = ENV['arireg_wsdl']
  config.endpoint = ENV['arireg_host']
  config.cache_period = Setting.days_to_keep_business_registry_cache.days
end