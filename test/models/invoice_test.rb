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

  def test_invalid_without_date
    @invoice.date = nil
    assert @invoice.invalid?
  end

  def test_seller_address
    invoice = Invoice.new(seller_city: 'Anytown',
                          seller_street: 'Main Street',
                          seller_state: nil,
                          seller_zip: nil)
    assert_equal 'Main Street, Anytown', invoice.seller_address
  end

  def test_calculates_subtotal
    invoice_item = InvoiceItem.new(price: 25, quantity: 2)
    invoice = Invoice.new(items: [invoice_item, invoice_item])
    assert_equal 100, invoice.subtotal
  end

  def test_calculates_vat_amount
    invoice_item = InvoiceItem.new(price: 25, quantity: 2)
    invoice_items = [invoice_item, invoice_item]
    invoice = Invoice.new(vat_rate: VATRate.new(10), items: invoice_items)

    assert_equal 10, invoice.vat_amount
  end

  def test_persists_calculated_vat_amount
    invoice_item = invoice_items(:one).dup
    invoice_item.assign_attributes(price: 25, quantity: 2)

    @invoice.vat_rate = nil
    invoice = @invoice.dup
    invoice.vat_rate = VATRate.new(10)
    invoice.items = [invoice_item, invoice_item.dup]
    invoice.save!
    invoice.reload

    assert_equal 10, invoice.read_attribute(:vat_amount)
  end

  def test_calculates_total
    invoice_item = InvoiceItem.new(price: 25, quantity: 2)
    invoice = Invoice.new(vat_rate: VATRate.new(10), items: [invoice_item, invoice_item])
    assert_equal 110, invoice.total
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

  def test_cancelled_when_cancelled_at_is_present
    invoice = Invoice.new(cancelled_at: '2010-07-05')
    assert invoice.cancelled?
  end

  def test_cancelled_when_cancelled_at_is_absent
    invoice = Invoice.new(cancelled_at: nil)
    assert_not invoice.cancelled?
  end

  def test_valid_without_buyer_vat_number
    @invoice.buyer_vat_no = ''
    assert @invoice.valid?
  end

  def test_iterates_over_invoice_items
    invoice = Invoice.new(items: [InvoiceItem.new(description: 'test')])

    iteration_count = 0
    invoice.each do |invoice_item|
      assert_equal 'test', invoice_item.description
      iteration_count += 1
    end

    assert_equal 1, iteration_count
  end
end
