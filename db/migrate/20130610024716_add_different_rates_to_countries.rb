class AddDifferentRatesToCountries < ActiveRecord::Migration
  def up
  	add_column :countries, :landline_rate, :decimal
  	add_column :countries, :mobile_rate, :decimal
  	add_column :countries, :satellite_rate, :decimal
  end

  def down
  	remove_column :countries, :landline_rate
  	remove_column :countries, :mobile_rate
  	remove_column :countries, :satellite_rate
  end
end
