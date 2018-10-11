require 'test_helper'

class AdminAreaInvoiceDetailsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:admin)
    @invoice = invoices(:valid)
  end

  def test_vat_section_is_visible_when_vat_rate_defined
    @invoice.update!(vat_rate: VATRate.new(5))
    visit admin_invoice_path(@invoice)

    within '.totals' do
      assert_text 'VAT 5.0%'
    end
  end

  def test_vat_section_is_not_visible_when_no_vat_rate
    @invoice.update!(vat_rate: NoVATRate.instance)
    visit admin_invoice_path(@invoice)

    within '.totals' do
      assert_no_text 'VAT'
    end
  end
end
