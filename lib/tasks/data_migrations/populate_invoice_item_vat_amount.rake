namespace :data_migrations do
  task populate_invoice_item_vat_amount: :environment do
    processed_invoice_item_count = 0

    InvoiceItem.transaction do
      InvoiceItem.find_each do |invoice_item|
        invoice_item.send(:persist_calculated_vat_amount)
        invoice_item.save!
        processed_invoice_item_count += 1
      end
    end

    puts "Invoice items processed: #{processed_invoice_item_count}"
  end
end
