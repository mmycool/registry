require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def test_calculates_amount
    item = InvoiceItem.new(price: 5, quantity: 2)
    assert_equal 10, item.amount
  end

  def test_calculates_vat_amount
    invoice = Invoice.new(vat_rate: BigDecimal('0.2'))
    item = InvoiceItem.new(price: 10, quantity: 1, invoice: invoice)
    assert_equal 2, item.vat_amount
  end

  def test_calculates_total
    invoice = Invoice.new(vat_rate: BigDecimal('0.2'))
    item = InvoiceItem.new(price: 10, quantity: 1, invoice: invoice)
    assert_equal 12, item.total
  end
end
