class AddCimPaymentProfileIdToPaymentProfiles < ActiveRecord::Migration
  def up
  	add_column :payment_profiles, :cim_payment_profile_id, :integer
  end

  def down
  	remove_column :payment_profiles, :cim_payment_profile_id
  end
end
