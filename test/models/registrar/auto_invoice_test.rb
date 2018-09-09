require 'test_helper'

class RegistrarAutoInvoiceTest < ActiveSupport::TestCase
  setup do
    @registrar = registrars(:bestnames)
  end

  def test_valid_without_low_balance_threshold
    @registrar.low_balance_threshold = nil
    assert @registrar.valid?
  end

  def test_low_balance_threshold_range_validation
    @registrar.low_balance_threshold = -1
    assert @registrar.invalid?

    @registrar.low_balance_threshold = 0
    assert @registrar.valid?

    @registrar.low_balance_threshold = 0.01
    assert @registrar.valid?
  end

  def test_fractional_low_balance_threshold
    @registrar.low_balance_threshold = 0.01
    @registrar.save!
    assert Money.from_amount(0.01), @registrar.low_balance_threshold
  end

  def test_valid_without_top_up_amount
    @registrar.top_up_amount = nil
    assert @registrar.valid?
  end

  def test_top_up_amount_range_validation
    @registrar.top_up_amount = -1
    assert @registrar.invalid?

    @registrar.top_up_amount = 0
    assert @registrar.invalid?

    @registrar.top_up_amount = 0.01
    assert @registrar.valid?
  end

  def test_fractional_top_up_amount
    @registrar.top_up_amount = 0.01
    @registrar.save!
    assert Money.from_amount(0.01), @registrar.top_up_amount
  end

  def test_valid_without_iban
    @registrar.iban = ''
    assert @registrar.valid?
  end

  def test_ungrouped_iban_is_valid
    @registrar.iban = 'DE91100000000123456789'
    assert @registrar.valid?
  end

  def test_grouped_iban_is_valid
    @registrar.iban = 'DE91 1000 0000 0123 4567 89'
    assert @registrar.valid?
  end

  def test_invalid_iban_format
    @registrar.iban = 'invalid'
    assert @registrar.invalid?
  end

  def test_normalize_iban_when_persisted
    @registrar.iban = '  de91 1000 0000 0123 4567 89  '
    @registrar.save!
    @registrar.reload
    assert_equal 'DE91100000000123456789', @registrar.iban
  end

  def test_do_not_normalize_iban_unless_persisted
    @registrar.iban = 'DE91 1000 0000 0123 4567 89'
    assert_equal 'DE91 1000 0000 0123 4567 89', @registrar.iban
  end
end