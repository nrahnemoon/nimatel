class CreateWholesalerRates < ActiveRecord::Migration
  def change
    create_table :wholesaler_rates do |t|
      t.string :country
      t.string :description
      t.decimal :rate, :precision => 12, :scale => 8
      t.decimal :billing_increment
      t.decimal :min_charge
      t.integer :wholesaler_id

      t.timestamps
    end
  end
end
