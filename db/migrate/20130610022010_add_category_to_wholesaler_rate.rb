class AddCategoryToWholesalerRate < ActiveRecord::Migration
  def up
  	add_column :wholesaler_rates, :category, :integer
  end

  def down
  	remove_column :wholesaler_rates, :category
  end
end
