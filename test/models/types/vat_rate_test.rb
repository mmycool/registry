require 'test_helper'

class VATRateTypeTest < ActiveSupport::TestCase
  setup do
    @type = Types::VATRate.new
  end

  def test_type_casts_string_to_vat_rate
    assert VATRate.new(BigDecimal('5.5')), @type.type_cast_from_user('5.5')
  end

  def test_type_casts_empty_string_to_null_object
    assert_kind_of NoVATRate, @type.type_cast_from_user('')
  end

  def test_skips_type_casting_vat_rate
    assert_equal VATRate.new(5), @type.type_cast_from_user(VATRate.new(5))
  end

  def test_skips_type_casting_null_vat_rate
    assert_equal NoVATRate.instance, @type.type_cast_from_user(NoVATRate.instance)
  end

  def test_serializes_vat_rate_to_decimal
    assert_equal BigDecimal(5), @type.type_cast_for_database(VATRate.new(5))
  end

  def test_serializes_null_object_to_null
    assert_nil @type.type_cast_for_database(NoVATRate.instance)
  end

  def test_deserializes_decimal_to_vat_rate
    assert_equal VATRate.new(5), @type.type_cast_from_database(BigDecimal(5))
  end

  def test_deserializes_nil_to_null_object
    assert_kind_of NoVATRate, @type.type_cast_from_database(nil)
  end
end
