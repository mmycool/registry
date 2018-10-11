require 'test_helper'

class PopulateInvoiceItemsVATRateTaskTest < ActiveSupport::TestCase
  setup do
    @invoice = invoices(:valid)
    @invoice_item = invoice_items(:one)
  end

  def test_populates_invoice_items_with_invoice_vat_rate
    @invoice.update!(vat_rate: VATRate.new(5))
    @invoice_item.update!(vat_rate: NoVATRate.instance)

    capture_io { run_task }
    @invoice_item.reload

    assert_equal VATRate.new(5), @invoice_item.vat_rate
  end

  def test_output
    @invoice.update!(vat_rate: VATRate.new(5))
    @invoice_item.update!(vat_rate: NoVATRate.instance)
    assert_output("Invoice items processed: 1\n") { run_task }
  end

  private

  def run_task
    Rake::Task['data_migrations:populate_invoice_items_vat_rate'].execute
  end
end
