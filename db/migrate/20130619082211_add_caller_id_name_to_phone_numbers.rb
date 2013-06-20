class AddCallerIdNameToPhoneNumbers < ActiveRecord::Migration
  def up
  	add_column :phone_numbers, :caller_id_name, :string
  end

  def down
  	remove_column :phone_numbers, :caller_id_name
  end
end
