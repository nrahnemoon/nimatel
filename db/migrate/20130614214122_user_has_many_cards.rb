class UserHasManyCards < ActiveRecord::Migration
  def up
  	add_column :cards, :user_id, :integer
  end

  def down
  	remove_column :cards, :user_id
  end
end
