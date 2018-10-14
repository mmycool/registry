namespace :data_migrations do
  task convert_registrar_vat_rate: [:environment] do
    processed_registrar_count = 0

    Registrar.transaction do
      Registrar.where.not(vat_rate: nil).each do |registrar|
        already_converted = !registrar.vat_rate_before_type_cast.start_with?('0.')
        next if already_converted

        new_vat_rate = VATRate.new(BigDecimal(registrar.vat_rate_before_type_cast) * 100)
        registrar.update!(vat_rate: new_vat_rate)

        processed_registrar_count += 1
      end
    end

    puts "Registrars processed: #{processed_registrar_count}"
  end
end
