require 'test_helper'

class RegistrarTest < ActiveSupport::TestCase
  def test_rejects_absent_accounting_customer_code
    registrar = Registrar.new(accounting_customer_code: nil)
    registrar.validate
    assert registrar.errors.added?(:accounting_customer_code, :blank)
  end

  def test_rejects_absent_country_code
    registrar = Registrar.new(country_code: nil)
    registrar.validate
    assert registrar.errors.added?(:country_code, :blank)
  end
end
