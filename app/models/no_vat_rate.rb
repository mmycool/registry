class NoVATRate
  include Singleton

  def vat_amount(*)
    0
  end

  def format
    'No VAT'
  end

  def no_vat?
    true
  end

  def to_d
    0
  end
end
