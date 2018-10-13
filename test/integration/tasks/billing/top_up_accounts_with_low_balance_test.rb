require 'test_helper'

class TopUpAccountsWithLowBalanceTaskTest < ActiveSupport::TestCase
  setup do
    ENV['auto_account_top_up'] = 'true'
    @registrar = registrars(:bestnames)
    @registrar.update!(auto_invoice_iban: 'DE91100000000123456789')
  end

  def test_invoices_registrars_whose_balance_has_reached_low_balance_threshold
    @registrar.update!(auto_invoice_activated: true,
                       auto_invoice_low_balance_threshold: 10,
                       auto_invoice_top_up_amount: 100)
    @registrar.cash_account.update!(balance: 10)

    assert_difference -> { @registrar.invoices.count } { capture_io { run_task } }
    invoice = Invoice.last
    assert_equal 100, invoice.subtotal
  end

  def test_outputs_results_when_feature_is_enabled
    @registrar.update!(name: 'Acme',
                       auto_invoice_activated: true,
                       auto_invoice_low_balance_threshold: 10,
                       auto_invoice_top_up_amount: 100)
    @registrar.cash_account.update!(balance: 10)

    assert_output(%Q(Registrar "Acme" has been invoiced to 100.00\nInvoiced total: 1\n)) { run_task }
  end

  def test_does_not_invoice_registrars_who_has_at_least_one_automatically_generated_unpaid_invoice
    invoice = invoices(:valid)
    invoice.update!(generated_automatically: true)

    @registrar.update!(auto_invoice_activated: true,
                       auto_invoice_low_balance_threshold: 10,
                       auto_invoice_top_up_amount: 100)
    @registrar.cash_account.update!(balance: 10)

    assert_no_difference -> { @registrar.invoices.count } { capture_io { run_task } }
  end

  def test_does_not_invoice_registrars_when_auto_top_up_is_deactivated
    @registrar.update!(auto_invoice_activated: false,
                       auto_invoice_low_balance_threshold: 10,
                       auto_invoice_top_up_amount: 100)
    @registrar.cash_account.update!(balance: 10)

    assert_no_difference -> { @registrar.invoices.count } { capture_io { run_task } }
  end

  def test_does_not_invoice_registrars_those_balance_did_not_reach_low_balance_threshold
    @registrar.update!(auto_invoice_activated: true,
                       auto_invoice_low_balance_threshold: 10,
                       auto_invoice_top_up_amount: 100)
    @registrar.cash_account.update!(balance: 11)

    assert_no_difference -> { @registrar.invoices.count } { capture_io { run_task } }
  end

  def test_does_not_invoice_registrars_when_feature_is_disabled
    ENV['auto_account_top_up'] = 'false'
    @registrar.update!(auto_invoice_activated: true,
                       auto_invoice_low_balance_threshold: 10,
                       auto_invoice_top_up_amount: 100)
    @registrar.cash_account.update!(balance: 10)

    assert_no_difference -> { @registrar.invoices.count } { capture_io { run_task } }
  end

  def test_outputs_error_when_feature_is_disabled
    ENV['auto_account_top_up'] = 'false'
    assert_output(nil, "Feature is disabled, aborting.\n") { run_task }
  end

  private

  def run_task
    Rake::Task['billing:top_up_accounts_with_low_balance'].execute
  end
end
