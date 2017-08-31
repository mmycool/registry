class DecomposePriceZoneId < ActiveRecord::Migration
  def up
    copy_zone_id_to_prices_zones
    remove_column :prices, :zone_id
  end

  def down
    raise IrreversibleMigration
  end

  private

  def copy_zone_id_to_prices_zones
    prices = Billing::Price.all
    puts "Going to process #{prices.count} prices"

    ActiveRecord::Base.transaction do
      prices.each do |price|
        price.zones << DNS::Zone.find(price.zone_id)
        print '.'
      end
    end

    puts 'Completed'
  end
end
