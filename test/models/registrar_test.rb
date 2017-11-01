require 'test_helper'

class RegistrarTest < ActiveSupport::TestCase
  def test_rejects_absent_country_code
    registrar = Registrar.new(country_code: nil)
    registrar.validate
    assert registrar.errors.added?(:country_code, :blank)
  end
end
