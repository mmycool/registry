namespace :data_migrations do
  task calculate_invoice_vat_amount: [:environment] do
    processed_invoice_count = 0

    Invoice.transaction do
      Invoice.where.not(vat_rate: nil).each do |invoice|
        vat_amount = invoice.vat_rate.vat_amount(invoice.subtotal)
        invoice.update_columns(vat_amount: vat_amount)

        processed_invoice_count += 1
      end
    end

    puts "Invoices processed: #{processed_invoice_count}"
  end
end
