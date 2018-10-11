require 'test_helper'

class RegistryTest < ActiveSupport::TestCase
  setup do
    @registry = Registry.send(:new)
  end

  def test_implements_singleton
    assert_equal Registry.instance.object_id, Registry.instance.object_id
  end

  def test_returns_vat_rate
    original_vat_rate_setting = Setting.registry_vat_prc
    Setting.registry_vat_prc = 0.205

    assert_equal VATRate.new(BigDecimal('20.5')), @registry.vat_rate

    Setting.registry_vat_prc = original_vat_rate_setting
  end
end
