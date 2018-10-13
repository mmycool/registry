namespace :billing do
  desc 'Invoice registrars with low balance'

  task top_up_accounts_with_low_balance: :environment do
    if ENV['auto_account_top_up'] == 'false'
      $stderr.puts 'Feature is disabled, aborting.'
      next
    end

    invoiced_registrar_count = 0

    Registrar.all.each do |registrar|
      next unless registrar.auto_invoice_activated?
      next if registrar.balance > registrar.auto_invoice_low_balance_threshold

      has_unpaid_auto_generated_invoices = registrar.invoices
                                             .joins("LEFT JOIN #{AccountActivity.table_name} activities" \
                                                    " ON (activities.invoice_id = #{Invoice.table_name}.id)")
                                             .where(cancelled_at: nil)
                                             .where(generated_automatically: true)
                                             .having('COUNT(activities.id) = 0')
                                             .group('invoices.id').any?
      next if has_unpaid_auto_generated_invoices

      invoice_amount = registrar.auto_invoice_top_up_amount
      registrar.issue_prepayment_invoice(invoice_amount)

      puts %Q(Registrar "#{registrar}" has been invoiced to #{format('%.2f', invoice_amount)})
      invoiced_registrar_count += 1
    end

    puts "Invoiced total: #{invoiced_registrar_count}"
  end
end
