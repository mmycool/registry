require 'test_helper'

class AutoInvoiceTaskTest < TaskTestCase
  setup do
    Application.enable_feature(:auto_invoice)
  end

  def test_invoice_registrars_with_low_balance
    registrar = registrars(:bestnames)
    registrar.update!(auto_invoice: true,
                      low_balance_threshold: 1,
                      top_up_amount: 10)
    accounts(:cash).update!(balance: 0)

    invoice = Invoice.last
    assert_difference -> { registrar.invoices.count } do
      Rake::Task['billing:auto_invoice'].execute
    end
    assert_equal Money.from_amount(10), invoice.total
  end

  def test_show_results
    registrar = registrars(:bestnames)
    registrar.update!(name: 'hotnames',
                      auto_invoice: true,
                      low_balance_threshold: 1,
                      top_up_amount: 10)
    accounts(:cash).update!(balance: 0)

    stdout = with_captured_stdout { Rake::Task['billing:auto_invoice'].execute }
    assert_equal %q(Registrar "hotnames" has been invoiced to EUR 10.00\nInvoiced total: 1\n),
                 stdout
  end

  def test_abort_when_feature_is_disabled
    Application.disable_feature(:auto_invoice)
    stderr = with_captured_stderr { Rake::Task['billing:auto_invoice'].execute }
    assert_equal "Feature is disabled, aborting.\n", stderr
  end
end