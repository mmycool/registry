require 'test_helper'

class ConvertInvoiceVATRateTaskTest < ActiveSupport::TestCase
  setup do
    @invoice = invoices(:valid)
  end

  def test_converts_invoice_vat_rate
    @invoice.update_columns(vat_rate: '0.205')

    capture_io { run_task }
    @invoice.reload

    assert_equal VATRate.new(BigDecimal('20.5')), @invoice.vat_rate
  end

  def test_keeps_invoices_with_no_vat_intact
    @invoice.update_columns(vat_rate: NoVATRate.instance)

    capture_io { run_task }
    @invoice.reload

    assert_equal NoVATRate.instance, @invoice.vat_rate
  end

  def test_keeps_invoices_with_zero_vat_intact
    @invoice.update_columns(vat_rate: VATRate.new(0))

    capture_io { run_task }
    @invoice.reload

    assert_equal VATRate.new(0), @invoice.vat_rate
  end

  def test_outputs_results
    eliminate_effect_of_other_invoices
    @invoice.update_columns(vat_rate: '0.205')
    assert_output("Invoices processed: 1\n") { run_task }
  end

  private

  def eliminate_effect_of_other_invoices
    Invoice.update_all(vat_rate: NoVATRate.instance)
  end

  def run_task
    Rake::Task['data_migrations:convert_invoice_vat_rate'].execute
  end
end
