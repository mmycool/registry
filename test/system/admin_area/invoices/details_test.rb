require 'test_helper'

class AdminAreaInvoiceDetailsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:admin)
    @invoice = invoices(:valid)
  end

  def test_show_vat_when_included
    @invoice.update!(vat_rate: VATRate.new(5))
    visit admin_invoice_path(@invoice)

    within '.totals' do
      assert_text 'VAT 5.0%'
    end
  end

  def test_hide_vat_when_excluded
    @invoice.update!(vat_rate: ExemptVATRate.instance)
    p @invoice.vat_rate
    p @invoice.read_attribute(:vat_rate)
    exit
    visit admin_invoice_path(@invoice)

    within '.totals' do
      assert_no_text 'VAT'
    end
  end
end
