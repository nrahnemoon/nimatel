class AddMinBalanceToRenewalPlan < ActiveRecord::Migration
  def up
  	add_column :renewal_plans, :min_balance, :decimal, :precision => 8, :scale => 2
  end

  def down
  	remove_column :renewal_plans, :min_balance
  end
end
