require 'test_helper'

class AdminAreaRegistrarDetailsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:admin)
    @registrar = registrars(:bestnames)
  end

  def test_registrar_details
    @registrar.accounting_customer_code = 'US0001'
    @registrar.vat_no = 'US12345'
    @registrar.language = 'en'
    @registrar.billing_email = 'billing@bestnames.test'
    @registrar.save(validate: false)

    visit admin_registrar_path(@registrar)
    assert_text 'Accounting customer code US0001'
    assert_text 'VAT number US12345'
    assert_text 'Language English'
    assert_text 'billing@bestnames.test'
  end

  def test_vat
    @registrar.update_columns(vat_rate: VATRate.new(5))
    visit admin_registrar_path(@registrar)
    assert_text 'VAT rate 5.0%'
  end

  def test_no_vat
    @registrar.update_columns(vat_rate: NoVATRate.instance)
    visit admin_registrar_path(@registrar)
    assert_text 'VAT rate No VAT'
  end
end
