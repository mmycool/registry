class ExemptVATRate
  def initialize(*)

  end

  def vat_amount(*)
    0
  end

  def format
    'No VAT'
  end

  def to_d
    0
  end

  def included_on_invoice?
    false
  end

  def ==(other)
    other.is_a?(self.class)
  end

  def blank?
    true
  end
end
