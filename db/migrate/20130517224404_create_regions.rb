class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :region_code
      t.integer :country_id

      t.timestamps
    end
  end
end
