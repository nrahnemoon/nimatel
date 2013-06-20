class AddPhoneNumberRelationToTransaction < ActiveRecord::Migration
  def up
  	add_column :transactions, :phone_number_id, :integer
  end

  def down
  	remove_column :transactions, :phone_number_id
  end
end
