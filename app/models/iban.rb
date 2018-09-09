class IBAN
  def initialize(iban)
    @iban = iban
  end

  def normalize
    iban.gsub(/\s+/, '').upcase
  end

  def to_s
    format
  end

  private

  attr_reader :iban

  def format
    iban.scan(/.{1,4}/).join("\s")
  end
end