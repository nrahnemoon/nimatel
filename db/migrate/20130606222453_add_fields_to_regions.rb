class AddFieldsToRegions < ActiveRecord::Migration
  def up
  	remove_column :regions, :region_code
  	add_column :regions, :prefix, :decimal
  	add_column :regions, :type, :integer
  	add_column :regions, :registrar, :string
  end

  def down
  	add_column :regions, :region_code, :string
  	remove_column :regions, :prefix
  	remove_column :regions, :type
  	remove_column :regions, :registrar
  end
end
