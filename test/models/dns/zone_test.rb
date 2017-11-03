require 'test_helper'

class ZoneTest < ActiveSupport::TestCase
  def test_rejects_absent_accounting_product_code
    zone = DNS::Zone.new(accounting_product_code: nil)
    zone.validate
    assert zone.errors.added?(:accounting_product_code, :blank)
  end
end
