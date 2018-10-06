require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  setup do
    @original_days_to_keep_overdue_invoices_active_setting =
      Setting.days_to_keep_overdue_invoices_active
    @invoice = invoices(:valid)
  end

  teardown do
    Setting.days_to_keep_overdue_invoices_active =
      @original_days_to_keep_overdue_invoices_active_setting
  end

  def test_valid
    assert @invoice.valid?
  end

  def test_calculates_subtotal
    invoice_item = InvoiceItem.new
    invoice = Invoice.new(items: [invoice_item, invoice_item])

    invoice_item.stub(:amount, 5) do
      assert_equal 10, invoice.subtotal
    end
  end

  def test_calculates_total
    invoice_item = InvoiceItem.new
    invoice = Invoice.new(items: [invoice_item, invoice_item])

    invoice_item.stub(:total, 5) do
      assert_equal 10, invoice.total
    end
  end

  def test_returns_persisted_total
    assert_equal BigDecimal('16.50'), @invoice.total
  end

  def test_seller_address
    invoice = Invoice.new(seller_city: 'Anytown',
                          seller_street: 'Main Street',
                          seller_state: nil,
                          seller_zip: nil)
    assert_equal 'Main Street, Anytown', invoice.seller_address
  end

  def test_cancel_overdue_cancels_overdue_invoices
    travel_to Time.zone.parse('2010-07-05')
    Setting.days_to_keep_overdue_invoices_active = 1
    @invoice.update!(due_date: '2010-07-03')

    Invoice.cancel_overdue_invoices
    @invoice.reload

    assert @invoice.cancelled?
  end

  def test_cancel_overdue_keeps_unpaid_invoices_intact
    travel_to Time.zone.parse('2010-07-05')
    Setting.days_to_keep_overdue_invoices_active = 1
    @invoice.update!(due_date: '2010-07-04')

    Invoice.cancel_overdue_invoices

    assert_not @invoice.cancelled?
  end

  def test_extract_date_from_created_at
    invoice = Invoice.new(created_at: Time.zone.parse('2010-07-05 00:00'))
    assert_equal Date.parse('2010-07-05'), invoice.date
  end

  def test_cancelled_when_cancelled_at_is_present
    invoice = Invoice.new(cancelled_at: '2010-07-05')
    assert invoice.cancelled?
  end

  def test_cancelled_when_cancelled_at_is_absent
    invoice = Invoice.new(cancelled_at: nil)
    assert_not invoice.cancelled?
  end
end
