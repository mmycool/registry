class Registry
  include Singleton

  def vat_rate
    Setting.registry_vat_prc
  end
end
