class RemoveCountryFromWholesalerRateAndAddPrefixes < ActiveRecord::Migration
  def up
  	remove_column :wholesaler_rates, :country
  	add_column :wholesaler_rates, :prefix, :decimal
  end

  def down
  	add_column :wholesaler_rates, :country, :string
  	remove_column :wholesaler_rates, :prefix
  end
end
