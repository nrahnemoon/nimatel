class AddBinToPaymentProfiles < ActiveRecord::Migration
  def up
  	add_column :payment_profiles, :bin, :string
  end

  def down
  	remove_column :payment_profiles, :bin
  end
end
