CompanyRegister.configure do |config|
  config.username = ENV['company_register_username']
  config.password = ENV['company_register_password']
  config.cache_store = Rails.cache
  config.cache_period = ENV['company_register_cache_period_days'].to_i.days
end