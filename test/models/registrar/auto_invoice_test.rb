require 'test_helper'

class RegistrarAutoInvoiceTest < ActiveSupport::TestCase
  setup do
    @registrar = registrars(:bestnames)
  end

  def test_deactivated_by_default
    registrar = Registrar.new
    assert_not registrar.auto_invoice_activated
  end

  def test_valid_without_low_balance_threshold_when_deactivated
    @registrar.auto_invoice_activated = false
    @registrar.auto_invoice_low_balance_threshold = nil
    assert @registrar.valid?
  end

  def test_invalid_without_low_balance_threshold_when_activated
    @registrar.auto_invoice_activated = true
    @registrar.auto_invoice_low_balance_threshold = nil
    assert @registrar.invalid?
  end

  def test_low_balance_threshold_validation
    @registrar.auto_invoice_low_balance_threshold = -1
    assert @registrar.invalid?

    @registrar.auto_invoice_low_balance_threshold = 0
    assert @registrar.valid?

    @registrar.auto_invoice_low_balance_threshold = 0.01
    assert @registrar.valid?
  end

  def test_valid_without_top_up_amount_when_deactivated
    @registrar.auto_invoice_activated = false
    @registrar.auto_invoice_top_up_amount = nil
    assert @registrar.valid?
  end

  def test_invalid_without_top_up_amount_when_activated
    @registrar.auto_invoice_activated = true
    @registrar.auto_invoice_top_up_amount = nil
    assert @registrar.invalid?
  end

  def test_invalid_when_top_up_amount_is_less_than_minimum_deposit_setting
    @original_minimum_deposit_setting = Setting.minimum_deposit

    Setting.minimum_deposit = 5
    @registrar.auto_invoice_top_up_amount = 4

    assert @registrar.invalid?
  end

  def test_valid_without_iban_when_deactivated
    @registrar.auto_invoice_activated = false
    @registrar.auto_invoice_iban = nil
    assert @registrar.valid?
  end

  def test_invalid_without_iban_when_activated
    @registrar.auto_invoice_activated = true
    @registrar.auto_invoice_iban = nil
    assert @registrar.invalid?
  end

  def test_ungrouped_iban_is_valid
    @registrar.auto_invoice_iban = 'DE91100000000123456789'
    assert @registrar.valid?
  end

  def test_grouped_iban_is_valid
    @registrar.auto_invoice_iban = 'DE91 1000 0000 0123 4567 89'
    assert @registrar.valid?
  end

  def test_invalid_iban_format
    @registrar.auto_invoice_iban = 'invalid'
    assert @registrar.invalid?
  end

  def test_normalizes_auto_invoice_iban_when_persisted
    @registrar.update!(auto_invoice_iban: '  de91 1000 0000 0123 4567 89  ')
    @registrar.reload
    assert_equal 'DE91100000000123456789', @registrar.auto_invoice_iban_before_type_cast
  end

  def test_does_not_normalize_auto_invoice_iban_unless_persisted
    @registrar.auto_invoice_iban = 'DE91 1000 0000 0123 4567 89'
    assert_equal 'DE91 1000 0000 0123 4567 89', @registrar.auto_invoice_iban
  end
end
