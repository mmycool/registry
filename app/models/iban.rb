class IBAN
  REGEXP = /\A\s*[a-z]{2}\s*[0-9]{2}.+\z/i
  private_constant :REGEXP

  def initialize(iban)
    @iban = iban
  end
  
  def normalize
    iban.gsub(/\s+/, '').upcase
  end

  def valid?
    iban =~ REGEXP
  end

  def invalid?
    !valid?
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
