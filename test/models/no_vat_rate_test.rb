require 'test_helper'

class NoVATRateTest < ActiveSupport::TestCase
  def test_implements_singleton
    assert_same NoVATRate.instance, NoVATRate.instance
  end

  def test_returns_zero_vat_amount
    assert NoVATRate.instance.vat_amount(10).zero?
  end

  def test_formats_to_human_readable_presentation
    assert_equal 'No VAT', NoVATRate.instance.format
  end

  def test_returns_zero_when_converted_to_decimal
    assert NoVATRate.instance.to_d.zero?
  end

  def test_no_vat
    assert NoVATRate.instance.no_vat?
  end
end
