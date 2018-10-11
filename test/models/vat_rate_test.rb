require 'test_helper'

class VATRateTest < ActiveSupport::TestCase
  def test_does_not_create_new_instance_from_nil
    exception = assert_raise ArgumentError do
      VATRate.new(nil)
    end
    assert_equal %q(Can't create from nil), exception.message
  end

  def test_does_not_create_new_instance_from_float
    exception = assert_raise ArgumentError do
      VATRate.new(1.1)
    end
    assert_equal %q(Can't create from a Float, use BigDecimal instead), exception.message
  end

  def test_does_not_create_new_instance_from_nonsense_value
    assert_raise ArgumentError do
      VATRate.new('nonsense')
    end
  end

  def test_does_not_create_new_instance_from_negative_value
    exception = assert_raise ArgumentError do
      VATRate.new(-1)
    end
    assert_equal 'Number -1 is out of allowed range (0-99)', exception.message
  end

  def test_does_not_create_new_instance_from_extremely_high_value
    exception = assert_raise ArgumentError do
      VATRate.new(100)
    end
    assert_equal 'Number 100 is out of allowed range (0-99)', exception.message
  end

  def test_create_new_instance_from_zero
    assert_nothing_raised ArgumentError do
      VATRate.new(0)
    end
  end

  def test_create_new_instance_from_high_value
    assert_nothing_raised ArgumentError do
      VATRate.new(99)
    end
  end

  def test_calculates_vat_amount
    assert_equal 100, VATRate.new(10).vat_amount(1000)
  end

  def test_formats_to_human_readable_presentation
    assert_equal '5.0%', VATRate.new(5).format
  end

  def test_equality
    assert_equal VATRate.new(1), VATRate.new(1)
  end

  def test_not_comparable_to_other_types
    assert_not_equal VATRate.new(1), nil
  end

  def test_converts_to_decimal
    assert_equal BigDecimal(10), VATRate.new(10).to_d
  end

  def test_converts_to_string
    assert_equal '10.0', VATRate.new(10).to_s
  end

  def test_inspect
    assert_equal '5.0', VATRate.new(5).inspect
  end

  def test_no_vat
    assert_not VATRate.new(1).no_vat?
  end
end
