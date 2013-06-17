class AddPaymentAndPhoneToUser < ActiveRecord::Migration
  def up
  	add_column :users, :cim_profile_id, :integer
  	add_column :users, :default_payment_profile_id, :integer
  end

  def down
  	remove_column :users, :cim_profile_id
  	remove_column :users, :default_payment_profile_id
  end
end
