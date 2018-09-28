namespace :billing do
  desc 'Invoice registrars with low balance'

  task auto_invoice: :environment do
    if Application.feature_disabled?(:auto_invoice)
      $stderr.puts 'Feature is disabled, aborting.'
      next
    end

    invoiced_registrar_count = 0

    Invoice.invoice_registrars_eligible_to_auto_invoice do |registrar, invoiced_amount|
      formatted_amount = invoiced_amount.format(symbol: false,
                                                with_currency: true,
                                                thousands_separator: ' ',
                                                decimal_mark: ',')
      puts %Q(Registrar "#{registrar}" has been invoiced to #{formatted_amount})
      invoiced_registrar_count += 1
    end

    puts "Invoiced total: #{invoiced_registrar_count}"
  end
end