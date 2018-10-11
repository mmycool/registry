require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def test_calculates_amount
    invoice_item = InvoiceItem.new(price: 5, quantity: 2)
    assert_equal 10, invoice_item.amount
  end

  def test_calculates_total
    invoice_item = InvoiceItem.new(price: 50, quantity: 2, vat_amount: 10)
    assert_equal 110, invoice_item.total
  end
end
