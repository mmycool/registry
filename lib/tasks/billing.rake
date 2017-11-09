namespace :billing do
  desc 'Cancels overdue invoices'

  task cancel_overdue_invoices: :environment do
    Invoice.cancel_overdue
  end
end
