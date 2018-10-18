class VATRate
  ALLOWED_VALUE_RANGE = 0..99
  private_constant :ALLOWED_VALUE_RANGE

  def initialize(value)
    raise ArgumentError, %q(Can't create from nil) if value.nil?
    raise ArgumentError, %q(Can't create from a Float, use BigDecimal instead) if value.is_a?(Float)
    raise ArgumentError, %Q(Number #{value} is out of allowed range (0-99)) unless ALLOWED_VALUE_RANGE.cover?(value)
    @value = value
  end

  def vat_amount(amount)
    amount * value / 100
  end

  def format
    Kernel.format('%.1f%', value)
  end

  def ==(other)
    return false unless other.is_a?(VATRate)
    value == other.value
  end

  def to_d
    value.to_d
  end

  def to_s
    value.to_d.to_s('f')
  end

  def inspect
    to_s
  end

  def included_on_invoice?
    true
  end

  protected

  attr_reader :value
end
