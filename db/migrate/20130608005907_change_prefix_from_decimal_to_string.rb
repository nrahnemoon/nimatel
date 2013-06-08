class ChangePrefixFromDecimalToString < ActiveRecord::Migration
  def up
  	change_column :wholesaler_rates, :prefix, :string
  	change_column :regions, :prefix, :string
  end

  def down
  	change_column :wholesaler_rates, :prefix, :decimal
  	change_column :regions, :prefix, :decimal
  end
end
