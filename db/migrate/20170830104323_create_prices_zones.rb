class CreatePricesZones < ActiveRecord::Migration
  def up
    create_join_table :prices, :zones
    add_foreign_key :prices_zones, :prices, column: :price_id, primary_key: :id
    add_foreign_key :prices_zones, :zones, column: :zone_id, primary_key: :id

    execute <<-SQL
      ALTER TABLE prices_zones ADD CONSTRAINT unique_price_id_zone_id UNIQUE (price_id, zone_id)
    SQL
  end

  def down
    drop_join_table :prices, :zones
  end
end
