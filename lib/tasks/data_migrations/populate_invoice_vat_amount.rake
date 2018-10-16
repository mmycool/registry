namespace :data_migrations do
  task populate_invoice_vat_amount: [:environment] do
    processed_invoice_count = 0

    Invoice.transaction do
      Invoice.find_each do |invoice|
        invoice.send(:persist_calculated_vat_amount)
        invoice.save!

        processed_invoice_count += 1
      end
    end

    puts "Invoices processed: #{processed_invoice_count}"
  end
end
