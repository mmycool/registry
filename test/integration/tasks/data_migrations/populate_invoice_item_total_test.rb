require 'test_helper'

class PopulateInvoiceItemTotalTaskTest < ActiveSupport::TestCase
  setup do
    @invoice_item = invoice_items(:one)
  end

  def test_populates_invoice_item_total
    @invoice_item.invoice.update!(vat_rate: VATRate.new(10))
    @invoice_item.update_columns(total: nil, price: 50, quantity: 2)
    @invoice_item.reload
    assert_nil @invoice_item.read_attribute(:total)

    capture_io { run_task }
    @invoice_item.reload

    assert_equal 110, @invoice_item.read_attribute(:total)
  end

  def test_outputs_results
    @invoice_item.update_columns(total: nil)
    assert_output("Invoice items processed: 1\n") { run_task }
  end

  private

  def run_task
    Rake::Task['data_migrations:populate_invoice_item_total'].execute
  end
end
