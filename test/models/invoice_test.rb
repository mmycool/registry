require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def test_requires_due_date
    invoice = Invoice.new(due_date: nil)
    invoice.validate
    assert invoice.errors.added?(:due_date, :blank)
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

  def test_requires_vat_rate
    invoice = Invoice.new(vat_rate: nil)
    invoice.validate
    assert invoice.errors.added?(:vat_rate, :blank)
  end

  def test_seller_address
    invoice = Invoice.new(seller_city: 'Anytown',
                          seller_street: 'Main Street',
                          seller_state: nil,
                          seller_zip: nil)
    assert_equal 'Main Street, Anytown', invoice.seller_address
  end

  def test_cancels_overdue
    travel_to Time.zone.parse('2010-07-07')
    Setting.days_to_keep_overdue_invoices_active = 1

    Invoice.cancel_overdue

    assert invoices(:overdue).cancelled?
    refute invoices(:outstanding).cancelled?
  end
end
