require 'test_helper'

class CalculateInvoiceVATAmountTaskTest < ActiveSupport::TestCase
  setup do
    @invoice = invoices(:valid)
  end

  def test_calculates_invoice_vat_amount
    invoice_item = InvoiceItem.new(description: 'any', price: 100, quantity: 1, unit: 'any')
    @invoice.update!(vat_rate: VATRate.new(10), items: [invoice_item])

    capture_io { run_task }
    @invoice.reload

    assert_equal 10, @invoice.vat_amount
  end

  def test_output
    Invoice.update_all(vat_rate: NoVATRate.instance)
    @invoice.update_columns(vat_rate: VATRate.new(5))
    assert_output("Invoices processed: 1\n") { run_task }
  end

  private

  def run_task
    Rake::Task['data_migrations:calculate_invoice_vat_amount'].execute
  end
end
