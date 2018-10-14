namespace :data_migrations do
  task convert_invoice_vat_rate: [:environment] do
    processed_invoice_count = 0

    Invoice.transaction do
      Invoice.where.not(vat_rate: nil).find_each do |invoice|
        already_converted = !invoice.vat_rate_before_type_cast.start_with?('0.')
        next if already_converted

        new_vat_rate = VATRate.new(BigDecimal(invoice.vat_rate_before_type_cast) * 100)
        invoice.update!(vat_rate: new_vat_rate)

        processed_invoice_count += 1
      end
    end

    puts "Invoices processed: #{processed_invoice_count}"
  end
end
