class UserHasManyPhoneNumbers < ActiveRecord::Migration
  def up
  	add_column :phone_numbers, :user_id, :integer
  end

  def down
  	remove_column :phone_numbers, :user_id
  end
end
