require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def setup
    @invoice_item = invoice_items(:one)
  end

  def test_fixture_is_valid
    assert @invoice_item.valid?
  end

  def test_calculates_amount
    invoice_item = InvoiceItem.new(price: 5, quantity: 2)
    assert_equal 10, invoice_item.amount
  end

  def test_calculates_vat_amount
    invoice = Invoice.new(vat_rate: VATRate.new(10))
    invoice_item = InvoiceItem.new(invoice: invoice, price: 50, quantity: 2)

    assert_equal 10, invoice_item.vat_amount
  end

  def test_persists_calculated_vat_amount
    invoice = invoices(:valid)
    invoice.vat_rate = VATRate.new(10)

    invoice_item = @invoice_item.dup
    invoice_item.assign_attributes(price: 50, quantity: 2)
    invoice_item.save!
    invoice_item.reload

    assert_equal 10, invoice_item.read_attribute(:vat_amount)
  end

  def test_calculates_total
    invoice = Invoice.new(vat_rate: VATRate.new(10))
    invoice_item = InvoiceItem.new(invoice: invoice, price: 50, quantity: 2)

    assert_equal 110, invoice_item.total
  end

  def test_persists_calculated_total
    invoice = invoices(:valid)
    invoice.vat_rate = VATRate.new(10)

    invoice_item = @invoice_item.dup
    invoice_item.assign_attributes(price: 50, quantity: 2)
    invoice_item.save!
    invoice_item.reload

    assert_equal 110, invoice_item.read_attribute(:total)
  end
end
