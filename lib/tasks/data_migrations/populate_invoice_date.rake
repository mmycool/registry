namespace :data_migrations do
  task populate_invoice_date: [:environment] do
    processed_invoice_count = 0

    Invoice.transaction do
      Invoice.find_each do |invoice|
        next if invoice.date?

        invoice_date = invoice.created_at.to_date
        invoice.update!(date: invoice_date)
        processed_invoice_count += 1
      end
    end

    puts "Invoice processed: #{processed_invoice_count}"
  end
end
