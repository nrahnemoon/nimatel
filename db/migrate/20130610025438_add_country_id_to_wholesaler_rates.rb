class AddCountryIdToWholesalerRates < ActiveRecord::Migration
  def up
  	add_column :wholesaler_rates, :country_id, :integer
  end

  def down
  	remove_column :wholesaler_rates, :country_id
  end
end
