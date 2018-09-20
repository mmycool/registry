namespace :billing do
  desc 'Invoice registrars with low balance'

  task auto_invoice: :environment do
    if Application.feature_disabled?(:auto_invoice)
      $stderr.puts 'Feature is disabled, aborting.'
      next
    end

    invoiced_registrar_count = 0

    Registrar.invoice_registrars_with_low_balance do |registrar, amount|
      puts %Q(Registrar "#{registrar}" has been invoiced to #{amount.format(symbol: false,
                                                                            with_currency: true,
                                                                            thousands_separator: ' ',
                                                                            decimal_mark: ',')})
      invoiced_registrar_count += 1
    end

    puts "Invoiced total: #{invoiced_registrar_count}"
  end
end