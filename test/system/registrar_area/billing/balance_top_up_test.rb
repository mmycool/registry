require 'test_helper'

class BalanceTopUpTest < ApplicationSystemTestCase
  setup do
    sign_in users(:api_bestnames)
  end

  def test_creates_new_invoice
    travel_to Time.zone.parse('2010-07-05')
    original_registry_vat_rate = Setting.registry_vat_prc
    Setting.registry_vat_prc = 0.1

    visit registrar_invoices_url
    click_link_or_button 'Add deposit'
    fill_in 'Amount', with: '100'

    assert_difference 'Invoice.count' do
      click_link_or_button 'Add'
    end

    invoice = Invoice.last

    assert_equal Date.parse('2010-07-05'), invoice.date
    assert_equal VATRate.new(10), invoice.vat_rate
    assert_equal 110, invoice.total
    assert_text 'Please pay the following invoice'

    Setting.registry_vat_prc = original_registry_vat_rate
  end
end
