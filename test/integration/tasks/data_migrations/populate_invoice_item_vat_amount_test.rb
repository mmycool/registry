require 'test_helper'

class PopulateInvoiceItemVATAmountTaskTest < ActiveSupport::TestCase
  setup do
    @invoice_item = invoice_items(:one)
  end

  def test_calculates_invoice_item_vat_amount
    @invoice_item.invoice.update!(vat_rate: VATRate.new(10))
    @invoice_item.update_columns(vat_amount: nil, price: 50, quantity: 2)
    @invoice_item.reload
    assert_nil @invoice_item.read_attribute(:vat_amount)

    capture_io { run_task }
    @invoice_item.reload

    assert_equal 10, @invoice_item.read_attribute(:vat_amount)
  end

  def test_outputs_results
    @invoice_item.update_columns(vat_amount: nil)
    assert_output("Invoice items processed: 1\n") { run_task }
  end

  private

  def run_task
    Rake::Task['data_migrations:populate_invoice_item_vat_amount'].execute
  end
end
