require 'test_helper'

class PopulateInvoiceDateTaskTest < ActiveSupport::TestCase
  setup do
    @invoice = invoices(:valid)
  end

  def test_populates_invoice_date
    eliminate_effect_of_other_invoices
    @invoice.update_columns(date: nil, created_at: Time.zone.parse('2010-07-05'))

    capture_io { run_task }
    @invoice.reload

    assert_equal Date.parse('2010-07-05'), @invoice.date
  end

  def test_outputs_results
    eliminate_effect_of_other_invoices
    @invoice.update_columns(date: nil)

    assert_output("Invoice processed: 1\n") { run_task }
  end

  private

  def eliminate_effect_of_other_invoices
    Invoice.update_all(date: :now)
    @invoice.reload # Subsequent `@invoice.update!` does not work properly without this
  end

  def run_task
    Rake::Task['data_migrations:populate_invoice_date'].execute
  end
end
