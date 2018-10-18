require 'test_helper'

class RegistrarTest < ActiveSupport::TestCase
  setup do
    @registrar = registrars(:bestnames)
    @original_registry_country_setting = Setting.registry_country_code
    @original_default_language_setting = Setting.default_language
  end

  teardown do
    Setting.registry_country_code = @original_registry_country_setting
    Setting.default_language = @original_default_language_setting
  end

  def test_valid
    assert @registrar.valid?, proc { @registrar.errors.full_messages }
  end

  def test_invalid_without_name
    @registrar.name = ''
    assert @registrar.invalid?
  end

  def test_invalid_without_reg_no
    @registrar.reg_no = ''
    assert @registrar.invalid?
  end

  def test_invalid_without_email
    @registrar.email = ''
    assert @registrar.invalid?
  end

  def test_invalid_without_accounting_customer_code
    @registrar.accounting_customer_code = ''
    assert @registrar.invalid?
  end

  def test_invalid_without_country_code
    @registrar.country_code = ''
    assert @registrar.invalid?
  end

  def test_invalid_without_language
    @registrar.language = ''
    assert @registrar.invalid?
  end

  def test_has_default_language
    Setting.default_language = 'en'
    registrar = Registrar.new
    assert_equal 'en', registrar.language
  end

  def test_overrides_default_language
    Setting.default_language = 'en'
    registrar = Registrar.new(language: 'de')
    assert_equal 'de', registrar.language
  end

  def test_full_address
    assert_equal 'Main Street, New York, New York, 12345', @registrar.address
  end

  def test_reference_number_generation
    @registrar.validate
    refute_empty @registrar.reference_no
  end

  def test_invalid_with_vat_rate_when_registrar_is_home_vat_payer
    Setting.registry_country_code = 'US'
    @registrar.vat_country = 'US'
    @registrar.vat_rate = VATRate.new(5)

    assert @registrar.invalid?
    assert @registrar.errors.added?(:vat_rate, :present)
  end

  def test_invalid_without_vat_rate_when_registrar_is_foreign_vat_payer_and_vat_number_is_absent
    Setting.registry_country_code = 'US'
    @registrar.vat_country = 'DE'
    @registrar.vat_no = ''
    @registrar.vat_rate = NoVATRate.instance

    assert @registrar.invalid?
    assert @registrar.errors.added?(:vat_rate, :blank)
  end

  def test_invalid_with_vat_rate_when_registrar_is_foreign_vat_payer_and_vat_number_is_present
    Setting.registry_country_code = 'US'
    @registrar.vat_country = 'DE'
    @registrar.vat_no = 'valid'
    @registrar.vat_rate = VATRate.new(5)

    assert @registrar.invalid?
    assert @registrar.errors.added?(:vat_rate, :present)
  end

  def test_vat_rate_is_taken_from_registry_when_registrar_is_home_vat_payer_when_issuing_new_invoice
    Setting.registry_country_code = 'US'
    @registrar.vat_country = 'US'
    @registrar.vat_rate = VATRate.new(5)

    Registry.instance.stub(:vat_rate, VATRate.new(10)) do
      invoice = @registrar.issue_prepayment_invoice(100)
      assert_equal VATRate.new(10), invoice.vat_rate
    end
  end

  def test_vat_rate_is_taken_from_registrar_when_registrar_is_foreign_vat_payer_when_issuing_new_invoice
    Setting.registry_country_code = 'US'
    @registrar.vat_country = 'DE'
    @registrar.vat_rate = VATRate.new(5)

    Registry.instance.stub(:vat_rate, VATRate.new(10)) do
      invoice = @registrar.issue_prepayment_invoice(100)
      assert_equal VATRate.new(5), invoice.vat_rate
    end
  end

  def test_issues_new_invoice
    invoice = @registrar.issue_prepayment_invoice(100)

    invoice_item = invoice.items.first
    assert_equal 1, invoice.items.count
    assert_equal 'prepayment', invoice_item.description
    assert_equal 100, invoice_item.price
    assert_equal 1, invoice_item.quantity
    assert_equal 'piece', invoice_item.unit
  end

  def test_valid_without_vat_number
    @registrar.vat_no = ''
    assert @registrar.valid?
  end

  def test_vat_number_is_taken_from_registrar_when_issuing_new_invoice
    @registrar.vat_no = '1234'

    assert_difference -> { Invoice.count } do
      @registrar.issue_prepayment_invoice(100)
    end
    invoice = Invoice.last
    assert_equal '1234', invoice.buyer_vat_no
  end
end
