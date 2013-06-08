class RenameTypeForRegions < ActiveRecord::Migration
  def up
  	rename_column :regions, :type, :category
  end

  def down
  	rename_column :regions, :category, :type
  end
end
