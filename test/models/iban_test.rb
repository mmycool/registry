require 'test_helper'

class IBANTest < ActiveSupport::TestCase
  def test_normalization
    iban = IBAN.new('  de91 1000 0000 0123 4567 89  ')
    assert_equal 'DE91100000000123456789', iban.normalize
  end

  def test_human_readable_format
    iban = IBAN.new('DE91100000000123456789')
    assert_equal 'DE91 1000 0000 0123 4567 89', iban.to_s
  end
end