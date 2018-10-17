require 'test_helper'

class CancelOverdueInvoicesTest < ActiveSupport::TestCase
  setup do
    @invoice = invoices(:valid)
    eliminate_effect_of_other_invoices
    @original_days_to_keep_overdue_invoices_active_setting = Setting.days_to_keep_overdue_invoices_active
  end

  teardown do
    Setting.days_to_keep_overdue_invoices_active = @original_days_to_keep_overdue_invoices_active_setting
  end

  def test_cancels_overdue_invoices
    Setting.days_to_keep_overdue_invoices_active = 1
    travel_to Time.zone.parse('2010-07-05')
    @invoice.update_columns(due_date: '2010-07-03')

    capture_io { run_task }
    @invoice.reload

    assert @invoice.cancelled?
    assert_equal Time.zone.parse('2010-07-05 00:00'), @invoice.cancelled_at
  end

  def test_does_not_cancel_not_overdue_invoices
    Setting.days_to_keep_overdue_invoices_active = 1
    travel_to Time.zone.parse('2010-07-05')
    @invoice.update_columns(due_date: '2010-07-04')

    capture_io { run_task }
    @invoice.reload

    assert_not @invoice.cancelled?
  end

  def test_outputs_results
    Setting.days_to_keep_overdue_invoices_active = 1
    travel_to Time.zone.parse('2010-07-05')
    @invoice.update_columns(due_date: '2010-07-03')

    assert_output("Invoice ##{@invoice.id} is cancelled\nCancelled total: 1\n") { run_task }
  end

  private

  def eliminate_effect_of_other_invoices
    Invoice.connection.disable_referential_integrity do
      Invoice.delete_all("id != #{@invoice.id}")
    end
  end

  def run_task
    Rake::Task['billing:cancel_overdue_invoices'].execute
  end
end
