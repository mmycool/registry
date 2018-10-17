namespace :billing do
  task cancel_overdue_invoices: [:environment] do
    cancel_from = (Time.zone.now - Setting.days_to_keep_overdue_invoices_active.days).to_date

    overdue_invoices = Invoice.unbinded.where('due_date < ? AND cancelled_at IS NULL', cancel_from)
    overdue_invoice_ids = overdue_invoices.ids
    overdue_invoice_count = overdue_invoice_ids.size

    overdue_invoices.update_all(cancelled_at: Time.zone.now)

    puts overdue_invoice_ids.map { |invoice_id| "Invoice ##{invoice_id} is cancelled" }.join("\n")
    puts "Cancelled total: #{overdue_invoice_count}"
  end
end
