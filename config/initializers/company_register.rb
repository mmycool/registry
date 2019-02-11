CompanyRegister.configure do |config|
  config.username = ENV['company_register_username']
  config.password = ENV['company_register_password']
  config.wsdl = ENV['company_register_wsdl']
  config.endpoint = ENV['company_register_host']
  config.cache_store = Rails.cache
  config.cache_period = ENV['company_register_cache_period_days'].to_i.days
end