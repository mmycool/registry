require 'test_helper'

class RegistryTest < ActiveSupport::TestCase
  def setup
    @registry = Registry.instance
  end

  def test_vat_rate
    Setting.registry_vat_prc = 0.2
    assert 0.2, @registry.vat_rate
  end
end
