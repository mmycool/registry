require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def setup
    @invoice_item = invoice_items(:one)
  end

  def test_fixture_is_valid
    assert @invoice_item.valid?
  end

  def test_invalid_without_vat_amount
    @invoice_item.vat_amount = nil
    assert @invoice_item.invalid?
  end

  def test_calculates_amount
    invoice_item = InvoiceItem.new(price: 5, quantity: 2)
    assert_equal 10, invoice_item.amount
  end

  def test_calculates_total
    invoice_item = InvoiceItem.new(price: 50, quantity: 2, vat_amount: 10)
    assert_equal 110, invoice_item.total
  end
end
