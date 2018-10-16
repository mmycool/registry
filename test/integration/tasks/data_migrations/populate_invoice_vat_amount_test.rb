require 'test_helper'

class PopulateInvoiceVATAmountTaskTest < ActiveSupport::TestCase
  setup do
    @invoice = invoices(:valid)
    @invoice_item = invoice_items(:one)

    eliminate_effect_of_other_invoices
  end

  def test_populates_invoice_vat_amount
    @invoice.update_columns(vat_amount: nil, vat_rate: VATRate.new(10))
    @invoice_item.update_columns(price: 100, quantity: 1)
    @invoice.reload
    assert_nil @invoice.read_attribute(:vat_amount)

    capture_io { run_task }
    @invoice.reload

    assert_equal 10, @invoice.read_attribute(:vat_amount)
  end

  def test_outputs_results
    assert_output("Invoices processed: 1\n") { run_task }
  end

  private

  def eliminate_effect_of_other_invoices
    Invoice.connection.disable_referential_integrity do
      Invoice.delete_all("id != #{@invoice.id}")
    end
  end

  def run_task
    Rake::Task['data_migrations:populate_invoice_vat_amount'].execute
  end
end
