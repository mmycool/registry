require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def setup
    @invoice = invoices(:valid)
  end

  def test_valid
    assert @invoice.valid?
  end

  def test_requires_currency
    invoice = Invoice.new(currency: nil)
    invoice.validate
    assert invoice.errors.added?(:currency, :blank)
  end

  def test_requires_seller_name
    invoice = Invoice.new(seller_name: nil)
    invoice.validate
    assert invoice.errors.added?(:seller_name, :blank)
  end

  def test_requires_seller_iban
    invoice = Invoice.new(seller_iban: nil)
    invoice.validate
    assert invoice.errors.added?(:seller_iban, :blank)
  end

  def test_requires_buyer_name
    invoice = Invoice.new(buyer_name: nil)
    invoice.validate
    assert invoice.errors.added?(:buyer_name, :blank)
  end

  def test_allows_absent_vat_rate
    @invoice.vat_rate = nil
    @invoice.validate
    assert @invoice.valid?
  end

  def test_rejects_negative_vat_rate
    @invoice.vat_rate = -1
    @invoice.validate
    assert @invoice.invalid?
  end

  def test_rejects_vat_rate_greater_than_max
    @invoice.vat_rate = 100
    @invoice.validate
    assert @invoice.invalid?
  end

  def test_seller_address
    invoice = Invoice.new(seller_city: 'Anytown',
                          seller_street: 'Main Street',
                          seller_state: nil,
                          seller_zip: nil)
    assert_equal 'Main Street, Anytown', invoice.seller_address
  end

  def test_cancels_overdue
    travel_to Time.zone.parse('2010-07-05')
    Setting.days_to_keep_overdue_invoices_active = 1

    Invoice.cancel_overdue

    assert invoices(:overdue).cancelled?
    refute invoices(:outstanding).cancelled?
  end

  def test_paid
    invoice = invoices(:paid)
    assert invoice.paid?
  end

  def test_date
    assert_equal Date.parse('2010-07-05'), @invoice.date
  end

  def test_calculates_subtotal
    assert_equal 20, @invoice.subtotal
  end

  def test_calculates_vat_amount
    assert_equal 0, @invoice.vat_amount
  end

  def test_calculates_total
    invoice = Invoice.new(invoices(:valid).attributes.except('id'))
    invoice.invoice_items.build(invoice_items(:valid).attributes.except('id'))
    invoice.invoice_items.build(invoice_items(:valid).attributes.except('id'))

    invoice.save!
    assert_equal 20, invoice.total
  end

  def test_applies_default_due_date_to_new
    travel_to Time.zone.parse('2010-07-05')
    Setting.days_to_keep_invoices_active = 5
    invoice = Invoice.new

    assert_equal Date.parse('2010-07-10'), invoice.due_date
  end

  def test_does_not_apply_default_due_date_to_persisted
    assert_equal Date.parse('2010-07-06'), @invoice.due_date
  end

  def test_overrides_default_due_date
    invoice = Invoice.new(due_date: Date.parse('2010-07-07'))
    assert_equal Date.parse('2010-07-07'), invoice.due_date
  end

  def test_cancelled
    invoice = invoices(:cancelled)
    assert invoice.cancelled?
  end
end
