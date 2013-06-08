class DropWholesalerPrefixesTable < ActiveRecord::Migration
  def up
  	drop_table :wholesaler_prefixes
  end

  def down
  	create_table :wholesaler_prefixes do |t|
      t.string :prefix
      t.integer :wholesaler_rate_id

      t.timestamps
    end
  end
end
