require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  setup do
    @invoice = invoices(:valid)
  end

  def test_fixture_is_valid
    assert @invoice.valid?, proc { @invoice.errors.full_messages }
  end

  def test_invalid_without_issue_date
    @invoice.issue_date = nil
    assert @invoice.invalid?
  end

  def test_optional_vat_rate
    @invoice.vat_rate = nil
    assert @invoice.valid?
  end

  def test_vat_rate_validation
    @invoice.vat_rate = -1
    assert @invoice.invalid?

    @invoice.vat_rate = 0
    assert @invoice.valid?

    @invoice.vat_rate = 99.9
    assert @invoice.valid?

    @invoice.vat_rate = 100
    assert @invoice.invalid?
  end

  def test_serializes_and_deserializes_vat_rate
    invoice = @invoice.dup
    invoice.items = @invoice.items
    invoice.vat_rate = BigDecimal('25.5')
    invoice.save!
    invoice.reload
    assert_equal BigDecimal('25.5'), invoice.vat_rate
  end

  def test_vat_rate_defaults_to_effective_vat_rate_of_a_registrar
    registrar = registrars(:bestnames)
    invoice = @invoice.dup
    invoice.vat_rate = nil
    invoice.buyer = registrar
    invoice.items = @invoice.items

    registrar.stub(:effective_vat_rate, BigDecimal(55)) do
      invoice.save!
    end

    assert_equal BigDecimal(55), invoice.vat_rate
  end

  def test_vat_rate_cannot_be_updated
    @invoice.vat_rate = BigDecimal(21)
    @invoice.save!
    @invoice.reload
    refute_equal BigDecimal(21), @invoice.vat_rate
  end

  def test_calculates_vat_amount
    assert_equal BigDecimal('1.5'), @invoice.vat_amount
  end

  def test_vat_amount_is_zero_when_vat_rate_is_blank
    @invoice.vat_rate = nil
    assert_equal 0, @invoice.vat_amount
  end

  def test_calculates_subtotal
    line_item = InvoiceItem.new
    invoice = Invoice.new(items: [line_item, line_item])

    line_item.stub(:item_sum_without_vat, BigDecimal('2.5')) do
      assert_equal BigDecimal(5), invoice.subtotal
    end
  end

  def test_returns_persisted_total
    assert_equal BigDecimal('16.50'), @invoice.total
  end

  def test_calculates_total
    line_item = InvoiceItem.new
    invoice = Invoice.new
    invoice.vat_rate = 10
    invoice.items = [line_item, line_item]

    line_item.stub(:item_sum_without_vat, BigDecimal('2.5')) do
      assert_equal BigDecimal('5.50'), invoice.total
    end
  end

  def test_valid_without_buyer_vat_no
    @invoice.buyer_vat_no = ''
    assert @invoice.valid?
  end

  def test_buyer_vat_no_is_taken_from_registrar_by_default
    registrar = registrars(:bestnames)
    registrar.vat_no = 'US1234'
    invoice = @invoice.dup
    invoice.buyer_vat_no = nil
    invoice.buyer = registrar
    invoice.items = @invoice.items
    invoice.save!
    assert_equal 'US1234', invoice.buyer_vat_no
  end

  def test_invalid_without_invoice_items
    @invoice.items = []
    assert @invoice.invalid?
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

  def test_seller_address
    invoice = Invoice.new(seller_city: 'Anytown',
                          seller_street: 'Main Street',
                          seller_state: nil,
                          seller_zip: nil)
    assert_equal 'Main Street, Anytown', invoice.seller_address
  end

  def test_cancels_overdue_invoices
    @original_days_to_keep_overdue_invoices_active_setting = Setting.days_to_keep_overdue_invoices_active
    Setting.days_to_keep_overdue_invoices_active = 1
    travel_to Time.zone.parse('2010-07-05')
    @invoice.update_columns(due_date: '2010-07-03')

    Invoice.cancel_overdue_invoices
    @invoice.reload

    assert @invoice.cancelled?

    Setting.days_to_keep_overdue_invoices_active = @original_days_to_keep_overdue_invoices_active_setting
  end

  def test_keeps_unpaid_not_overdue_invoices_intact
    @original_days_to_keep_overdue_invoices_active_setting = Setting.days_to_keep_overdue_invoices_active
    Setting.days_to_keep_overdue_invoices_active = 1
    travel_to Time.zone.parse('2010-07-05')
    @invoice.update_columns(due_date: '2010-07-04')

    Invoice.cancel_overdue_invoices

    assert_not @invoice.cancelled?

    Setting.days_to_keep_overdue_invoices_active = @original_days_to_keep_overdue_invoices_active_setting
  end
end
