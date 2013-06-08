class RemoveCountryCodeAndAddAlphasToCountries < ActiveRecord::Migration
  def up
  	add_column :countries, :alpha2, :string
  	add_column :countries, :alpha3, :string
  	remove_column :countries, :country_code
  end

  def down
  	remove_column :countries, :alpha2
  	remove_column :countries, :alpha3
  	add_column :countries, :country_code, :string
  end
end
