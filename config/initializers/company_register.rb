CompanyRegister.configure do |config|
  config.username = ENV['arireg_username']
  config.password = ENV['arireg_password']
  config.wsdl = ENV['arireg_wsdl']
  config.endpoint = ENV['arireg_host']
  config.cache_period = ENV['arireg_cache_period_days'].to_i.days
end