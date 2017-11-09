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
    Setting.days_to_keep_overdue_invoices_active = 35

    create(:invoice, created_at: Time.zone.now - 35.days, due_date: Time.zone.now - 30.days)
    Invoice.cancel_overdue_invoices

    assert_equal 1, Invoice.where(cancelled_at: nil).count
  end
end
