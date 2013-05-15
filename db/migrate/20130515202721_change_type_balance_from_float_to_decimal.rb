class ChangeTypeBalanceFromFloatToDecimal < ActiveRecord::Migration
  def up
  	change_column :cards, :balance, :decimal, :precision => 8, :scale => 2
  end

  def down
  	change_column :cards, :balance, :float
  end
end
