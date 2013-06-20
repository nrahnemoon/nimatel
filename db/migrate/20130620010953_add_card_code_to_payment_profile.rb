class AddCardCodeToPaymentProfile < ActiveRecord::Migration
  def up
  	add_column :payment_profiles, :card_code, :string
  end

  def down
  	remove_column :payment_profiles, :card_code
  end
end
