class ChangePinTypeFromIntegerToString < ActiveRecord::Migration
  def up
  	change_column :cards, :pin, :string
  end

  def down
  	change_column :cards, :pin, :integer
  end
end
