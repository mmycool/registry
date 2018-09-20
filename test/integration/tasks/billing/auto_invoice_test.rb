require 'test_helper'

class AutoInvoiceTaskTest < ActiveSupport::TestCase
  def test_output
    Application.enable_feature(:auto_invoice)
    registrar = registrars(:bestnames)
    registrar.update!(name: 'Acme',
                      auto_invoice: true,
                      low_balance_threshold: 1,
                      top_up_amount: 1000.10)
    registrar.cash_account.update!(balance: 0)

    assert_output(%Q(Registrar "Acme" has been invoiced to 1 000,10 EUR\nInvoiced total: 1\n)) do
      Rake::Task['billing:auto_invoice'].execute
    end
  end

  def test_abort_when_feature_is_disabled
    Application.disable_feature(:auto_invoice)

    assert_output(nil, "Feature is disabled, aborting.\n") do
      Rake::Task['billing:auto_invoice'].execute
    end
  end
end