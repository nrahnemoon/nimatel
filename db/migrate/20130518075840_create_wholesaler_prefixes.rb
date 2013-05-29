class CreateWholesalerPrefixes < ActiveRecord::Migration
  def change
    create_table :wholesaler_prefixes do |t|
      t.string :prefix
      t.integer :wholesaler_rate_id

      t.timestamps
    end
  end
end
