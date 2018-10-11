namespace :data_migrations do
  task populate_invoice_items_vat_rate: [:environment] do
    processed_invoice_item_count = 0

    InvoiceItem.transaction do
      InvoiceItem.find_each do |invoice_item|
        invoice_item.update!(vat_rate: invoice_item.invoice.vat_rate)
        processed_invoice_item_count += 1
      end
    end

    puts "Invoice items processed: #{processed_invoice_item_count}"
  end
end
