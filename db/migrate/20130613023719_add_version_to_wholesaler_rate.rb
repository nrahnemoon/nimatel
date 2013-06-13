class AddVersionToWholesalerRate < ActiveRecord::Migration
  def up
  	add_column :wholesaler_rates, :version, :integer
  end

  def down
  	remove_column :wholesaler_rates, :version
  end
end
